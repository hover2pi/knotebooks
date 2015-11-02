class AddAuthlogicRpxMigration < ActiveRecord::Migration
  def self.up
    create_table :rpx_identifiers do |t|
      t.string  :identifier, :null => false
      t.string  :provider_name
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :rpx_identifiers, :identifier, :unique => true, :null => false
    add_index :rpx_identifiers, :user_id, :unique => false, :null => false
    
    change_column_default :users, :email, nil
    change_column_default :users, :difficulty, 12.5
    
    User.all(:conditions => "rpx_identifier IS NOT NULL").each do |user|
      user.rpx_identifiers << RPXIdentifier.create(:user => user, :provider_name => "Unknown", :identifier => user.rpx_identifier)
    end
    remove_column :users, :rpx_identifier
  end
  
  def self.down
    add_column :users, :rpx_identifier, :string
    
    RPXIdentifier.all.each do |rpx_ident|
      u = User.find(rpx_ident.user_id)
      u.rpx_identifier = rpx_ident.identifier
      u.save
    end
    
    change_column_default :users, :email, "user@example.com"
    change_column_default :users, :difficulty, nil

    drop_table :rpx_identifiers
    
    # == Customisation may be required here ==
    # Restore user model database constraints as appropriate
    # e.g.:
    #[:crypted_password, :password_salt].each do |field|
    #  User.all(:conditions => "#{field} is NULL").each { |user| user.update_attribute(field, "") if user.send(field).nil? }
    #  change_column :users, field, :string, :default => "", :null => false
    #end

  end
end
