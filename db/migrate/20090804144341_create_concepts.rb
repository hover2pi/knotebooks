class CreateConcepts < ActiveRecord::Migration
  def self.up
    create_table :concepts do |t|
      t.string :name

      t.timestamps
    end
    add_index :concepts, :name, :unique => true
  end

  def self.down
    drop_table :concepts
  end
end
