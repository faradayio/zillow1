class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.integer :zpid
      t.integer :statistical_region_id
      t.string :zipcode
      t.float :bathrooms
      t.integer :bedrooms
      t.integer :floorspace
      t.string :zillow_home_type
      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
