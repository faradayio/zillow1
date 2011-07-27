class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :appearances, :listing_id
    add_index :appearances, :appeared_at
    add_index :listings, :zpid, :unique => true
    add_index :listings, :statistical_area_id
  end

  def self.down
    remove_index :appearances, :listing_id
    remove_index :appearances, :appeared_at
    remove_index :listings, :zpid
    remove_index :listings, :statistical_area_id
  end
end
