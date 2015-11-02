class FavoritesController < ApplicationController
  before_filter :require_user, :except => :show
  
  def show
    @knotebook = Favorite.find(params[:id])
    @comments = @knotebook.comments
    @original = @knotebook.original
    
    respond_to do |format|
      format.html { render 'knotebooks/show' }
    end
  end
  
  def create
    @knotebook = Knotebook.find(params[:knotebook_id])
    @favorite = @knotebook.build_favorite(params[:knote_ids], :user => current_user)
    
    respond_to do |format|
      if @favorite.save
        flash.now[:notice] = "Knotebook added to Favorites!"
        # redirect_to user_favorite_url(current_user, @favorite)
        format.js { render :partial => 'shared/growl' }
      else
        flash.now[:notice] = "Something horrible happened!  Try again?"
        format.js { render :partial => 'shared/growl' }
      end
    end
  end
  
  def update
    @favorite = current_user.favorites.find(params[:id])
    @favorite.knotes = Knote.find(params[:knote_ids])
    
    respond_to do |format|
      if @favorite.save
        flash.now[:notice] = "Favorite successfully updated!"
        # redirect_to user_favorite_url(current_user, @favorite)
        format.js { render :partial => 'shared/growl' }
      else
        flash.now[:notice] = "Something horrible happened!  Try again?"
        format.js { render :partial => 'shared/growl' }
      end
    end
  end
end