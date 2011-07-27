# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110713183411) do

  create_table "appearances", :id => false, :force => true do |t|
    t.integer  "listing_id"
    t.datetime "appeared_at"
    t.string   "composite_identifier"
  end

  add_index "appearances", ["appeared_at"], :name => "index_appearances_on_appeared_at"
  add_index "appearances", ["listing_id"], :name => "index_appearances_on_listing_id"

  create_table "listings", :id => false, :force => true do |t|
    t.integer  "zpid"
    t.string   "statistical_area_id"
    t.string   "zipcode"
    t.float    "bathrooms"
    t.integer  "bedrooms"
    t.integer  "floorspace"
    t.string   "zillow_home_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "emission"
  end

  add_index "listings", ["statistical_area_id"], :name => "index_listings_on_statistical_area_id"
  add_index "listings", ["zpid"], :name => "index_listings_on_zpid", :unique => true

  create_table "statistical_areas", :id => false, :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
