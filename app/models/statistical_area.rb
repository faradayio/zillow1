class StatisticalArea < ActiveRecord::Base
  set_primary_key :name
  
  extend Cacheable
  extend ActiveSupport::Memoizable

  has_many :listings
  
  data_miner do
    import 'Zillow statistical areas', :url => 'http://www.zillow.com/static/xls/Zestimate_Accuracy_December_31_2009.xls', :sheet => 2, :errata => 'http://github.com/brighterplanet/zillow1/raw/master/public/zillow_statistical_areas_errata.csv' do
      key 'name', :field_name => 'CMSA'
    end
  end
  
  def url_encoded_name
    name.sub(',', '').gsub(' ', '+')
  end
  
  def identifier
    name.downcase.gsub(/[,\.]/, '').gsub(/[ -]/, '_')
  end
  
  # TODO andy add a different timestamp, updated_at is not trustworthy for the time series
  # make sure to change the references everywhere in the code
  def fetch_and_store_listings!
    ZillowSearch.new(url_encoded_name).results.each do |result|
      next if %w(lot multiFamily).include? result['homeType'] # skip irrelevant home types
      listings.find_or_create_by_zpid( Listing.zpid_from_url(result['detailPageLink']) ).tap { |l| l.update_attributes(
                                :zipcode => result['address']['zipcode'],
                                :bathrooms => result['bathrooms'].to_f.nonzero?,
                                :bedrooms => result['bedrooms'].to_i.nonzero?,
                                :zillow_home_type => (result['homeType'] == 'unknown' ? nil : result['homeType']),
                                :floorspace => result['finishedSqFt'].to_i.nonzero? ) }.tap(&:touch).calculate_emission!
    end
    clear_cache
  end
  
  def average_emission(day)
    (l = listings.on(day)).any? ? l.average(:emission) : nil
  end
  cacheify :average_emission, :ttl => 1.hour
  memoize :average_emission
  
  def emissions
    self.class.days.map { |d| average_emission d }
  end
  
  def clear_cache
    unmemoize_all
    uncacheify_all
  end

  class << self
    extend ActiveSupport::Memoizable
    
    def days
      connection.select_values('SELECT DISTINCT DATE(listings.updated_at) AS d FROM listings ORDER BY d').map { |raw| Date.parse raw }
    end
    cacheify :days, :ttl => 1.hour
    memoize :days
  
    def emissions
      all.inject({}) { |memo, s| memo[s.identifier] = s.emissions; memo }
    end

    def clear_cache
      unmemoize_all
      uncacheify_all
    end
  
    def fetch_and_store_listings!
      all.each do |statistical_area|
        statistical_area.fetch_and_store_listings!
        sleep 10
      end
      clear_cache
    end
  
    def leaderboard
      all.select { |s| s.average_emission(Date.today).present? }.sort_by { |s| s.average_emission Date.today }
    end
  end
end
