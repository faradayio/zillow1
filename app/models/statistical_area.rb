class StatisticalArea < ActiveRecord::Base
  set_primary_key :name
  
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
    name.downcase.gsub(/,/, '').gsub(/[ ]/, '_')
  end
  
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
  end
  
  def days
    listings.map { |l| l.updated_at.to_date }.uniq.sort
  end
  
  def emissions
    days.map { |d| listings.on(d).average(:emission).round.to_i }
  end
  
  def self.fetch_and_store_listings!
    all.each do |statistical_area|
      statistical_area.fetch_and_store_listings!
      sleep 10
    end
  end
  
  def self.leaderboard
    all.sort_by { |s| s.listings.today.average(:emission) }
  end
end
