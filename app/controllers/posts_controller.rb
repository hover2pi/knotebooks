class PostsController < ApplicationController
  before_filter :require_admin
  
  def create
    @post = Post.new(params[:post])

    if @post.save
      flash.now[:notice] = 'Post was successfully created.'
    end
    redirect_to('/news')
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      flash[:notice] = 'Post was successfully deleted'
      format.html { redirect_to pages_path(:news) }
    end
  end 
  
 
end
