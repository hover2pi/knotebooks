class CreateKnotings < ActiveRecord::Migration
  def self.up
    create_table :knotings do |t|
      t.references :knotebook
      t.references :knote

      t.timestamps
    end
  end

  def self.down
    drop_table :knotings
  end
end
