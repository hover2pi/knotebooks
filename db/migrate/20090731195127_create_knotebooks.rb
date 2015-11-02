class CreateKnotebooks < ActiveRecord::Migration
  def self.up
    create_table :knotebooks do |t|
      t.references :user
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :knotebooks
  end
end
