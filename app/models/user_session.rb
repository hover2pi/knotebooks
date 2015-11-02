class UserSession < Authlogic::Session::Base
  rpx_key RPX_API_KEY
  rpx_extended_info
  
  def map_rpx_data
    self.attempted_record.new_user = attempted_record.new_record?
    self.attempted_record.login = @rpx_data['profile']['preferredUsername'] if attempted_record.login.blank?
    self.attempted_record.email = (@rpx_data['profile']['verifiedEmail'] || @rpx_data['profile']['email']) if attempted_record.email.blank?

    self.attempted_record.name = @rpx_data['profile']['displayName'] if attempted_record.name.blank?
    self.attempted_record.website = @rpx_data['profile']['url'] if attempted_record.website.blank?
    # self.attempted_record.photo_url = @rpx_data['profile']['photo'] if attempted_record.photo_url.blank?
  end
end