class AddPositionToKnotings < ActiveRecord::Migration
  def self.up
    add_column :knotings, :position, :integer
  end

  def self.down
    remove_column :knotings, :position
  end
end
