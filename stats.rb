require 'sqlite3'
require 'sequel'

db = Sequel.connect('sqlite://zillow.sqlite3')

set = db[:statistical_areas].
  select(:name, :zipcode, :bathrooms, :bedrooms, :floorspace, :zillow_home_type, :emission, :appeared_at).
  join(:listings, :statistical_area_id => :name).
    join(:appearances, :listing_id => :zpid)

puts set.to_csv(true)



