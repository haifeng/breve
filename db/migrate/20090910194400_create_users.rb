class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :nickname
      t.string    :password
      t.string    :email
      t.integer   :points, :default => 1
      t.string    :reset_key
      t.timestamp :reset_expires_at, :default => Time.now
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
