class CommentsController < ApplicationController
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    
    respond_to do |format|
      if @comment.save
        flash[:notice] = "Comment Posted!"
        format.html { redirect_to @commentable }
      else
        flash[:error] = "Error posting comment"
        format.html { redirect_to @commentable }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.author == current_user || current_user.is_admin?

    respond_to do |format|
      flash[:notice] = 'Comment was successfully deleted'
      format.html { redirect_to @comment.commentable }
      # format.xml  { head :ok }
    end
  end
  
  private
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end