class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :parent_id
      t.integer :commentable_id
      t.string  :commentable_type
      t.integer :user_id
      t.text    :content
      t.integer :points, :default => 1
      t.float   :rank,   :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
