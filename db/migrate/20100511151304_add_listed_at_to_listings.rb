class AddListedAtToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :listed_at, :datetime
    Listing.update_all 'listed_at = updated_at'
  end

  def self.down
    remove_column :listings, :listed_at
  end
end
