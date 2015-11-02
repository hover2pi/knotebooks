class PagesController < ApplicationController
  PAGES = /about|faq|tou|news|video|index/
  
  def show
    render :action => params[:page]
  end
end
