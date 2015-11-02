class AddStartTimeToKnotes < ActiveRecord::Migration
  def self.up
    add_column :knotes, :start_time, :string
    add_column :knotes, :end_time, :string
  end

  def self.down
    remove_column :knotes, :start_time
    remove_column :knotes, :end_time
  end
end
