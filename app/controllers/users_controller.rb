class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :except => [:new, :create, :index, :show]
  
  def index
    @users = User.paginate(:page => params[:page], :order => "updated_at DESC", :per_page => 15)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id], :include => [:knotebooks, { :comments => :user }])
    @knotebooks = @user.knotebooks.paginate(:page => params[:page], :per_page => 5, :order => "updated_at DESC")
    @favorites = @user.favorites.paginate(:page => params[:favorite_page], :per_page => 5)
    @comments = @user.comments
  end

  def new
    @user = User.new
  end

  def edit
    @new_user = session[:new_user]
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    # @user.rpx_identifier = @rpx_identifier = session[:rpx_identifier] if session[:rpx_identifier]
    
    if @user.save
      flash[:notice] = 'You have successfully registered.'
      redirect_to @user
    else
      render :action => :new
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      session[:new_user] = nil if session[:new_user]
      flash[:notice] = 'Your information has been successfully updated.'
      redirect_to @user
    else
      @new_user = session[:new_user] if session[:new_user]
      render :action => "edit"
    end
  end
  
  # This action has the special purpose of receiving an update of the RPX identity information
	# for current user - to add RPX authentication to an existing non-RPX account.
	# RPX only supports :post, so this cannot simply go to update method (:put)
	def authorize
		@user = current_user
		if @user.save
			flash[:notice] = "You have successfully added RPX authentication to your account."
			redirect_to current_user
		else
			render :action => 'edit'
		end
	end
end