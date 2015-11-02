class UpdateCharacterLimits < ActiveRecord::Migration
  def self.up
    change_column :knotes, :source, :text
    change_column :knotes, :caption, :text
    change_column :users, :bio, :text
    change_column :users, :education, :text
    change_column :users, :work, :text
  end

  def self.down
    change_column :knotes, :source, :string
    change_column :knotes, :caption, :string
    change_column :users, :bio, :string
    change_column :users, :education, :string
    change_column :users, :work, :string
  end
end
