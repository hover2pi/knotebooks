class AddFlagToKnotebooks < ActiveRecord::Migration
  def self.up
    add_column :knotebooks, :ignore, :boolean, :default => false
    
    Knotebook.with_exclusive_scope do
      Knotebook.update_all("ignore = false")
    end
  end

  def self.down
    remove_column :knotebooks, :ignore
  end
end
