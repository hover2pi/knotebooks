class ChangeIndexForConceptsAndChangeAbstractToText < ActiveRecord::Migration
  def self.up
    remove_index :concepts, :name
    add_index :concepts, :name
    change_column :knotebooks, :abstract, :text
  end

  def self.down
    change_column :knotebooks, :abstract, :string
    remove_index :concepts, :name
    add_index :concepts, :name, :unique => true
  end
end
