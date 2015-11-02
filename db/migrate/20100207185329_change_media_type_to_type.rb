class ChangeMediaTypeToType < ActiveRecord::Migration
  def self.up
    add_column :knotes, :url, :string
    Knote.all.each { |k| k.update_attribute(:media_type, k.media_type.capitalize) }
    Knote.find_all_by_media_type("Video").each { |v| v.update_attribute(:url, v.content) }
    rename_column :knotes, :media_type, :type
    change_column_default :knotes, :type, "Html"
  end

  def self.down
    change_column_default :knotes, :type, nil
    rename_column :knotes, :type, :media_type
    Knote.all.each { |k| k.update_attribute(:media_type, k.media_type.downcase) }
    Video.all.each { |v| v.update_attribute(:content, v.url) }
    remove_column :knotes, :url
  end
end