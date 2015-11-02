class AddTypeToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :type, :string, :default => "Knotebook"
    
    kbs = Knotebook.send(:with_exclusive_scope) { Knotebook.find_all_by_favorite(true) }
    
    for kb in kbs do
      kb.update_attribute(:type, "Favorite")
    end
    
    remove_column :knotebooks, :favorite
  end

  def self.down
    add_column :knotebooks, :favorite, :boolean, :default => false
    
    for f in Favorite.all do
      f.update_attribute(:favorite, true)
    end
      
    remove_column :knotebooks, :type
  end
end
