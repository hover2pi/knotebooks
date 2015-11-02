class AddOrgNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :org_name, :string
  end

  def self.down
    remove_column :users, :org_name
  end
end
