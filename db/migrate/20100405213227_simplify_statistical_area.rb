class SimplifyStatisticalArea < ActiveRecord::Migration
  def self.up
    remove_column :statistical_areas, :cbsa_code
    remove_column :statistical_areas, :population
    change_column :listings, :statistical_area_id, :string
  end

  def self.down
    add_column :statistical_areas, :cbsa_code, :integer
    add_column :statistical_areas, :population, :integer
    change_column :listings, :statistical_area_id, :integer
  end
end
