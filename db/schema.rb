# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150809022253) do

  create_table "cards", force: :cascade do |t|
    # We will need the concept of different decks since we have decided to allow multiple
    # different "rooms" to play within.
    t.string   "deck_number"
    t.string   "value"
    t.string   "suit"
    # This field can be used to track who currently posses the card
    # Ex. "Jacob", "sink1", "source2", "none"
    t.string   "owned_by"
    # Though we won't probably have a use for these fields, it doesn't hurt to keep them
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
