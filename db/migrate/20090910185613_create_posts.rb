class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      #t.references :content, :polymorphic => true
      #t.integer :content_id
      #t.string  :content_type
      
      t.integer :user_id
      t.integer :section_id, :default => 1
      t.integer :points,     :default => 1
      t.float   :rank,       :default => 0
      t.timestamps

      # post specific
      t.string  :url
      t.string  :title
      t.text    :text

      # counter caches
      t.integer :comments_count, :default => 0
    end
  end

  def self.down
    drop_table :posts
  end
end
