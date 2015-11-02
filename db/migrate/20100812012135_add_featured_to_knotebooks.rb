class AddFeaturedToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :featured, :boolean, :default => false
    
    Knotebook.with_exclusive_scope do
      Knotebook.update_all("featured = false")
    end
    
    Knotebook.find(125).update_attribute(:featured, true)
  end

  def self.down
    remove_column :knotebooks, :featured
  end
end
