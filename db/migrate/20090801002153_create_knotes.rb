class CreateKnotes < ActiveRecord::Migration
  def self.up
    create_table :knotes do |t|
      t.references :user
      t.string     :title
      t.text       :content
      t.text       :source
      t.string     :content_type
      t.string     :media_type
      t.float      :difficulty

      t.timestamps
    end
  end

  def self.down
    drop_table :knotes
  end
end
