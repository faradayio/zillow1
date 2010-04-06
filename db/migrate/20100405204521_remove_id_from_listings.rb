class RemoveIdFromListings < ActiveRecord::Migration
  def self.up
    remove_column :listings, :id
  end

  def self.down
    add_column :listings, :id, :integer
  end
end
