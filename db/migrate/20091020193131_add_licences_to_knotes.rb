class AddLicencesToKnotes < ActiveRecord::Migration
  def self.up
    add_column :knotes, :license, :string
  end

  def self.down
    remove_column :knotes, :license
  end
end
