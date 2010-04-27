class StatisticalArea < ActiveRecord::Base
  set_primary_key :name
  
  has_many :listings
  
  data_miner do
    import 'Zillow statistical areas', :url => 'http://www.zillow.com/static/xls/Zestimate_Accuracy_December_31_2009.xls', :sheet => 2 do
      key 'name', :field_name => 'CMSA'
    end
  end
  
  def url_encoded_name
    name.sub(',', '').gsub(' ', '+')
  end
  
  def fetch_and_store_listings!
    ZillowSearch.new(url_encoded_name).results.each do |result|
      next if %w(lot multiFamily).include? result['homeType']
      listing = listings.find_or_create_by_zpid( Listing.zpid_from_url(result['detailPageLink']) ).update_attributes(
                                :zipcode => result['address']['zipcode'],
                                :bathrooms => result['bathrooms'].to_f.nonzero?,
                                :bedrooms => result['bedrooms'].to_i.nonzero?,
                                :zillow_home_type => (result['homeType'] == 'unknown' ? nil : result['homeType']),
                                :floorspace => result['finishedSqFt'].to_i.nonzero? )
      #listing.calculate_emission!
    end
  end
end