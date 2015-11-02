class User < ActiveRecord::Base
  has_many :knotebooks
  has_many :favorites
  has_many :knotes
  has_many :comments, :as => :commentable
  has_many :commentinos, :class_name => "Comment"
  
  acts_as_authentic do |c|
    # a.require_password_confirmation = false
    c.account_mapping_mode :internal
		c.account_merge_enabled true
  end

  validates_presence_of :name, :login
  validates_uniqueness_of :login, :case_sensitive => false
  validates_length_of :login, :within => 3..15
  validates_length_of :bio, :maximum => 1500, :allow_blank => true
  validates_length_of :work, :maximum => 512, :allow_blank => true
  validates_length_of :education, :maximum => 512, :allow_blank => true
  validates_length_of :website_description, :maximum => 128, :allow_blank => true
  validates_length_of :website, :maximum => 128, :allow_blank => true
  validates_format_of :logo, :with => URI::regexp("http"), :allow_blank => true
  validates_length_of :org_name, :maximum => 128, :allow_blank => true
  
  attr_accessible :email, :name, :difficulty, :bio, :website, :website_description, :photo_url, :education, :work, :login,
                  :password, :password_confirmation, :rpx_identifier, :new_user, :logo, :org_name
  
  def kbs
    knotebooks - favorites
  end
  
  def is_admin?
    [1,2].include?(id)
  end
  
  def is_org?
    self.organization? && !self.logo.blank?
  end
  
private
  # map_added_rpx_data maps additional fields from the RPX response into the user object during the "add RPX to existing account" process.
	# Override this in your user model to perform field mapping as may be desired
	# See https://rpxnow.com/docs#profile_data for the definition of available attributes
	#
	# "self" at this point is the user model. Map details as appropriate from the rpx_data structure provided.
	#
	def map_added_rpx_data( rpx_data )
		self.website    = rpx_data['profile']['url'] if website.blank?
		self.name       = rpx_data['profile']['displayName'] if name.blank?
		self.login      = rpx_data['profile']['preferredUsername'] if login.blank?
		self.email      = rpx_data['profile']['verifiedEmail'] || rpx_data['profile']['email'] if email.blank?
		# Why are we still letting people enter an email address if they have to signup through RPX? Take out "if email.blank?"
    # self.photo_url  = rpx_data['profile']['photo'] if photo_url.blank?
	end
  
  # Transfer all knotebooks to the new user
  def before_merge_rpx_data( from_user, to_user )
    RAILS_DEFAULT_LOGGER.info "in before_merge_rpx_data: migrate knotebooks, knotes and comments from #{from_user.login} to #{to_user.login}"
    to_user.knotebooks  << from_user.knotebooks
    to_user.knotes      << from_user.knotes
    to_user.comments    << from_user.comments
    to_user.commentinos << from_user.commentinos
  end
  
  # Delete the old user after a merge
  def after_merge_rpx_data( from_user, to_user )
    RAILS_DEFAULT_LOGGER.info "in after_merge_rpx_data: destroy #{from_user.inspect}" 
    from_user.destroy
  end
end

# user.rpx.identifiers == sRPXNow.map(, User)