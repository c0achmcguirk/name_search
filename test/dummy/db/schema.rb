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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110523005839) do

  create_table "person_search_name_person_joins", :force => true do |t|
    t.integer "name_id"
    t.integer "person_id"
    t.string  "person_klass"
  end

  add_index "person_search_name_person_joins", ["name_id"], :name => "index_person_search_name_person_joins_on_name_id"
  add_index "person_search_name_person_joins", ["person_id", "person_klass"], :name => "index_person_search_person_id_person_klass"

  create_table "person_search_name_relationships", :force => true do |t|
  end

  create_table "person_search_names", :force => true do |t|
    t.string  "text"
    t.integer "name_relationship_id"
  end

  add_index "person_search_names", ["name_relationship_id"], :name => "index_person_search_names_on_name_relationship_id"

end
