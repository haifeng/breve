class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email
      t.string    :password
      t.string    :lastname
      t.string    :firstname
      t.string    :alias
      t.integer   :points, :default => 1
      t.timestamps

      # quick & dirty role/privilege management (should move this out later)
      t.boolean   :admin, :default => false
      
      # activation and reset
      t.string    :activation_key
      t.timestamp :activation_expires_at, :default => Time.now
      
      t.string    :reset_key
      t.timestamp :reset_expires_at, :default => Time.now
      
      # counter caches
      t.integer :posts_count, :default => 0
      t.integer :comments_count, :default => 0
    end
  end

  def self.down
    drop_table :users
  end
end
