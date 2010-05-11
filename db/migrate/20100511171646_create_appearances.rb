class CreateAppearances < ActiveRecord::Migration
  def self.up
    remove_column :listings, :listed_at
    create_table :appearances, :id => false do |t|
      t.integer :listing_id
      t.datetime :appeared_at
      t.string :composite_identifier
    end
    Listing.all.each do |listing|
      listing.appearances.find_or_create_by_composite_identifier("#{listing.zpid}-#{listing.updated_at.to_i}").update_attributes :appeared_at => listing.updated_at 
    end
  end

  def self.down
    add_column :listings, :listed_at, :datetime
    drop_table :appearances
  end
end
