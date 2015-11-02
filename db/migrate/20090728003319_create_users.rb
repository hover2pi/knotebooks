class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.float  :difficulty
      t.text   :bio
      t.float  :difficulty
      t.string :website
      t.string :website_description
      t.string :education
      t.string :work
      
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :email, :default => "user@example.com"
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
