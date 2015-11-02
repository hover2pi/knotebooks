class AddFavoritesToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :favorite, :boolean, :default => false
    add_column :knotebooks, :original_id, :integer
  end

  def self.down
    remove_column :knotebooks, :original_id
    remove_column :knotebooks, :favorite
  end
end
