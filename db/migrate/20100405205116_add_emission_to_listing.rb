class AddEmissionToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :emission, :float
  end

  def self.down
    remove_column :listings, :emission
  end
end
