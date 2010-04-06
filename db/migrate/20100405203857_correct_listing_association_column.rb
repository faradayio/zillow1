class CorrectListingAssociationColumn < ActiveRecord::Migration
  def self.up
    rename_column :listings, :statistical_region_id, :statistical_area_id
  end

  def self.down
    rename_column :listings, :statistical_area_id, :statistical_region_id
  end
end
