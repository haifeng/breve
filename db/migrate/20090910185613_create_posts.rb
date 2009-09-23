class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string  :url
      t.string  :title
      t.text    :content
      t.integer :user_id
      t.integer :section_id, :default => 1
      t.integer :points,     :default => 1
      t.float   :rank,       :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
