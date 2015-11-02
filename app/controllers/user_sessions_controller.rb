class UserSessionsController < ApplicationController
  before_filter :require_user, :except => [:index, :new, :create]
  
  def index
    redirect_to current_user ? root_url : login_url
  end
  
  def new
    current_user_session.destroy if current_user_session
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    # Authentication is OK
    if @user_session.save
      # This is a new user
      # @user_session.errors.clear
      if @user_session.new_registration?
        flash[:notice] = "Welcome!  As a new user, please review your registration details before continuing."
        session[:new_user] = true
        redirect_to edit_user_path(:current)
        # render :template => 'users/edit'
      else
        if @user_session.registration_complete?
          flash[:notice] = "Login Successful!"
          redirect_back_or_default current_user
        else
          flash[:notice] = "Welcome back!  Please complete the required registration details before continuing."
          redirect_to edit_user_path(:current)
          # render :template => 'users/new'
        end
      end
    else
      flash[:error] = "Failed to login or register."
      redirect_to root_url
    end
  end
  
  def destroy
    current_user_session.destroy if current_user_session
    flash[:notice] = "Logged out"
    redirect_to root_url
  end
end
