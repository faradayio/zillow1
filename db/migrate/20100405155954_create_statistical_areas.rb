class CreateStatisticalAreas < ActiveRecord::Migration
  def self.up
    create_table :statistical_areas do |t|
      t.string :cbsa_code
      t.string :name
      t.integer :population
      t.timestamps
    end
  end

  def self.down
    drop_table :statistical_areas
  end
end
