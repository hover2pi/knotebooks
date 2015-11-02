class ConceptsController < ApplicationController
  before_filter :require_user, :only => :create

  def new
    @concept = Concept.new

    respond_to do |format|
      format.js { render :partial => @concept, :layout => false }
    end
  end

  def create
    @concept = Concept.find_by_name(params[:concept][:name]) || Concept.new(params[:concept])
    
    if @concept.save
      respond_to do |format|
        format.json { render :json => @concept }
      end
    end
  end
  
  def index
    @concepts = Concept.all
    
    respond_to do |format|
      # format.json { render :json => @concepts.to_json(:only => :name) }
      format.json { render :json => @concepts.map(&:name) }
    end
  end

end
