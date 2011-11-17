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

  def identifier
    name.downcase.gsub(/[,\.]/, '').gsub(/[ -]/, '_')
  end

  def fetch_and_store_listings!
    ZillowSearch.new(name).results.each do |result|
      listing = Listing.parse result
      next if listing.nil?

      changed = listing.changed?

      listing.save!

      time = Time.now
      a = listing.appearances.build :appeared_at => time
      a.composite_identifier = "#{listing.zpid}-#{time.to_i}" # can't be mass-assigned because it's the primary key
      a.save!

      listing.calculate_emission! if changed
    end
  ensure
    clear_method_cache :average_emission
  end
  
  def average_emission(day)
    sql = %{
      SELECT
        AVG(listings.emission) as avg_emission
      FROM listings
      INNER JOIN appearances ON listings.zpid = appearances.listing_id
      WHERE
        listings.statistical_area_id = '#{name}' AND
        appearances.appeared_at BETWEEN '#{day.to_time.to_formatted_s(:db)}' AND '#{day.to_time.tomorrow.to_formatted_s(:db)}' AND
        listings.emission IS NOT NULL
    }
    result = connection.select_value(sql)
    puts "#{name}, #{day}, got result #{result.inspect}"
    puts "result.to_s matches? #{(result.to_s =~ /\d/ ? result.to_f : nil).inspect}"
    result.to_s =~ /\d/ ? result.to_f : nil
  end
  cache_method :average_emission, 50.hours
  
  def average_emission_old(day)
    e = appearances.on(day)
    e = e.map { |appearance| appearance.listing.emission }.compact
    e.any? ? (e.sum / e.length) : nil
  end
    
  def emissions
    results = self.class.days.map { |d| average_emission d }
    if results.any?(&:nil?)
      nonnil_results = results.compact
      overall_average = nonnil_results.any? ? nonnil_results.sum / nonnil_results.length : nil
      results.map { |r| r.nil? ? overall_average : r }
    else
      results
    end
  end
  
  class << self
    def days
      connection.select_values('SELECT DISTINCT DATE(appearances.appeared_at) AS d FROM appearances WHERE appearances.appeared_at IS NOT NULL ORDER BY d DESC LIMIT 15').reverse
    end
    cache_method :days, 24.hours
  
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
