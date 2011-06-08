class StatisticalArea < ActiveRecord::Base
  set_primary_key :name
  
  has_many :listings
  has_many :appearances, :through => :listings
  
  data_miner do
    import  'Zillow statistical areas',
            :url => 'http://www.zillow.com/static/xls/Zestimate_Accuracy_December_31_2010.xls',
            :sheet => 2,
            :errata => { :url => 'http://github.com/brighterplanet/zillow1/raw/master/public/zillow_statistical_areas_errata.csv' } do
      key 'name', :field_name => 'CMSA'
    end
  end
  
  # sabshere 2/21/11
  # for cache_method
  def hash
    name.hash
  end
  
  def url_encoded_name
    name.sub(',', '').gsub(' ', '+')
  end
  
  def identifier
    name.downcase.gsub(/[,\.]/, '').gsub(/[ -]/, '_')
  end
  
  def fetch_and_store_listings!
    ZillowSearch.new(url_encoded_name).results.each do |result|
      next if %w(lot multiFamily).include? result['homeType'] # skip irrelevant home types

      zpid = Listing.zpid_from_url(result['detailPageLink'])

      listing = listings.find_or_initialize_by_zpid(zpid)
      listing.update_attributes!(
        :zipcode => result['address']['zipcode'],
        :bathrooms => result['bathrooms'].to_f.nonzero?,
        :bedrooms => result['bedrooms'].to_i.nonzero?,
        :zillow_home_type => (result['homeType'] == 'unknown' ? nil : result['homeType']),
        :floorspace => result['finishedSqFt'].to_i.nonzero?
      ) 
      time = Time.now
      appearance = listing.appearances.find_or_initialize_by_composite_identifier("#{listing.zpid}-#{time.to_i}")
      appearance.update_attributes! :appeared_at => time

      listing.calculate_emission!
    end
  ensure
    clear_method_cache :average_emission
  end
  
  def average_emission(day)
    (e = appearances.on(day).map { |appearance| appearance.listing.emission}.compact).any? ? (e.sum / e.length) : nil
  end
  cache_method :average_emission, 24.hours
    
  def emissions
    results = self.class.days.map { |d| average_emission d }
    if results.any?(&:nil?)
      nonnil_results = results.compact
      overall_average = nonnil_results.sum / nonnil_results.length
      results.map { |r| r.nil? ? overall_average : r }
    else
      results
    end
  end
  
  class << self
    def days
      connection.select_values('SELECT DISTINCT DATE(appearances.appeared_at) AS d FROM appearances WHERE appearances.appeared_at IS NOT NULL ORDER BY d LIMIT 15').map { |raw| Date.parse raw }
    end
    cache_method :days
  
    def emissions
      all.inject({}) { |memo, s| memo[s.identifier] = s.emissions; memo }
    end
  
    def fetch_and_store_listings!
      all.each do |statistical_area|
        statistical_area.fetch_and_store_listings!
        # prime the cache
        statistical_area.emissions
        sleep 5
      end
    ensure
      clear_method_cache :days
    end
  
    def leaderboard
      raise "There are no days" if days.empty?
      all.select { |s| s.average_emission(days.last).present? }.sort_by { |s| s.average_emission days.last }
    end
  end
end
