class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :comments, :id
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :concepts, :id
    add_index :conceptualizations, :id
    add_index :knotebooks, :id
    add_index :knotebooks, :original_id
    add_index :knotebooks, :user_id
    add_index :knotebooks, [:id, :type]
    add_index :knotes, :id
    add_index :knotes, :user_id
    add_index :knotes, [:id, :type]
    add_index :knotings, :id
    add_index :knotings, :knote_id
    add_index :knotings, :knotebook_id
    add_index :users, :id
  end

  def self.down
    remove_index :users, :id
    remove_index :knotings, :knotebook_id
    remove_index :knotings, :knote_id
    remove_index :knotings, :id
    remove_index :knotes, :user_id
    remove_index :knotes, :id
    remove_index :knotes, :column => [:id, :type]
    remove_index :knotebooks, :user_id
    remove_index :knotebooks, :original_id
    remove_index :knotebooks, :id
    remove_index :knotebooks, :column => [:id, :type]
    remove_index :conceptualizations, :id
    remove_index :concepts, :id
    remove_index :comments, :user_id
    remove_index :comments, :id
    remove_index :comments, :column => [:commentable_id, :commentable_type]
  end
end
