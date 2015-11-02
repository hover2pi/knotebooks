class ChangeKnoteDefaultDifficulty < ActiveRecord::Migration
  def self.up
    change_column_default :knotes, :difficulty, 37.5
  end

  def self.down
    change_column_default :knotes, :difficulty, 12.5
  end
end
