class StatisticalArea < ActiveRecord::Base
  set_primary_key :cbsa_code
  
  has_many :listings
  
  data_miner do
    import 'U.S. Census data', :url => 'http://www.census.gov/popest/metro/files/2009/CBSA-EST2009-alldata.csv', :select => lambda { |row| row[1].present? and row[2].blank? and row[3].blank? } do
      key   'cbsa_code', :field_name => 'CBSA'
      store 'name', :field_name => 'NAME'
      store 'population', :field_name => 'POPESTIMATE2009' 
    end
  end
  
  def zillow_region_name
    name.sub(',')
  end
end
