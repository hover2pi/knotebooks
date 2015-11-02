class JavascriptsController < ApplicationController
  def application
    respond_to do |format|
      format.js
    end
  end
  
  def new
    respond_to do |format|
      format.js
    end
  end
  
  def swap
    respond_to do |format|
      format.js { render :partial => "swap" }
    end
  end
end
