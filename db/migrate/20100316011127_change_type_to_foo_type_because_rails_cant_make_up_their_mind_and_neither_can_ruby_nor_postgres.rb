class ChangeTypeToFooTypeBecauseRailsCantMakeUpTheirMindAndNeitherCanRubyNorPostgres < ActiveRecord::Migration
  def self.up
    rename_column :knotebooks, :type, :knotebook_type
    rename_column :knotes, :type, :knote_type
  end

  def self.down
    rename_column :knotes, :knote_type, :type
    rename_column :knotebooks, :knotebook_type, :type
  end
end
