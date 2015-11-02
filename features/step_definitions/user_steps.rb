Given /^a new user$/ do
  @user = User.new
end

Given /^a logged out user$/ do
  @user = User.make
end

Given /^a logged out user named "(\w+)"$/ do |name|
  @user = User.make(name.downcase.to_sym)
end

Given /^a logged in user named "(\w+)"$/ do |name|
  @user = User.make(name.downcase.to_sym)
  visit login_path
  fill_in "user_session_login", :with => @user.login
  fill_in "user_session_password", :with => @user.password
  submit_form 'new_user_session'
end