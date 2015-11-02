class AddDeltaToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :knotebooks, :delta
  end
end
