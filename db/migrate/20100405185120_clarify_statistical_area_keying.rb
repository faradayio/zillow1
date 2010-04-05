class ClarifyStatisticalAreaKeying < ActiveRecord::Migration
  def self.up
    remove_column :statistical_areas, :id
    change_column :statistical_areas, :cbsa_code, :integer
  end

  def self.down
    add_column :statistical_areas, :id, :integer
    change_column :statistical_areas, :cbsa_code, :string
  end
end
