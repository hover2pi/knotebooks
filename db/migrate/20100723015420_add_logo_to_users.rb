class AddLogoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :logo, :text
    add_column :users, :organization, :boolean, :default => false
  end

  def self.down
    remove_column :users, :organization
    remove_column :users, :logo
  end
end
