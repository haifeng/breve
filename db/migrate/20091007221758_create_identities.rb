class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.string  :provider
      t.string  :uid
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :identities
  end
end
