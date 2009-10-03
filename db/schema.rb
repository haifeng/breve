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

ActiveRecord::Schema.define(:version => 20090918192812) do

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "text"
    t.integer  "points",           :default => 1
    t.float    "rank",             :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",   :default => 0
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "section_id",     :default => 1
    t.integer  "points",         :default => 1
    t.float    "rank",           :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "title"
    t.text     "text"
    t.integer  "comments_count", :default => 0
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "alias"
    t.integer  "points",                :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                 :default => false
    t.string   "activation_key"
    t.datetime "activation_expires_at", :default => '2009-10-02 17:13:35'
    t.string   "reset_key"
    t.datetime "reset_expires_at",      :default => '2009-10-02 17:13:35'
    t.integer  "posts_count",           :default => 0
    t.integer  "comments_count",        :default => 0
  end

  create_table "votes", :force => true do |t|
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.integer  "user_id"
    t.integer  "value",         :default => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
