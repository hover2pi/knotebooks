class AddAbstractToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :abstract, :string
  end

  def self.down
    remove_column :knotebooks, :abstract
  end
end
