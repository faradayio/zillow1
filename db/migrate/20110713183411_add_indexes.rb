class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :appearances, :listing_id
    add_index :listings, :zpid
    add_index :listings, :statistical_area_id
  end

  def self.down
  end
end
