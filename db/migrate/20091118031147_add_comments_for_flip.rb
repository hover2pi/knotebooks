class AddCommentsForFlip < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.belongs_to :commentable, :polymorphic => true
      t.belongs_to :user
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
