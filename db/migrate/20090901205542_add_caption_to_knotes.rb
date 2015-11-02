class AddCaptionToKnotes < ActiveRecord::Migration
  def self.up
    add_column :knotes, :caption, :string
  end

  def self.down
    remove_column :knotes, :caption
  end
end
