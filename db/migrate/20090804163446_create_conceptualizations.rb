class CreateConceptualizations < ActiveRecord::Migration
  def self.up
    create_table :conceptualizations do |t|
      t.references :topic, :null => false
      t.references :conceptualizable, :null => false
      t.string :conceptualizable_type, :null => false
      t.timestamps
    end
    add_index :conceptualizations, [:topic_id, :conceptualizable_id, :conceptualizable_type], :name => "conceptualization_index", :unique => true
  end

  def self.down
    drop_table :conceptualizations
  end
end
