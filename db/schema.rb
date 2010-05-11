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

ActiveRecord::Schema.define(:version => 20100511171646) do

  create_table "appearances", :id => false, :force => true do |t|
    t.integer  "listing_id"
    t.datetime "appeared_at"
    t.string   "composite_identifier"
  end

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

  create_table "statistical_areas", :id => false, :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
