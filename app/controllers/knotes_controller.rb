class KnotesController < ApplicationController
  before_filter :require_user, :except => [:show, :easier, :harder, :restore]
  before_filter :require_valid_user, :except => [:show, :easier, :harder, :restore]
  # before_filter { |c| @knotebook = Knotebook.find(c.params[:knotebook_id]) if c.params[:knotebook_id] }
  # 
  # def index
  #   @knotes = params[:id] ? Knote.by_concept(params[:id]).paginate(:page => params[:page]) : Knote.paginate(:page => params[:page])
  #   @knote = @knotes.first or raise ActiveRecord::RecordNotFound
  #   @position = 1
  # end
  # 
  # def show
  #   @media_type = params[:media_type] || "any"
  #   @knote = Knote.find(params[:id])
  # end

  def new
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    @knote = @knotebook.knotes.build(:user => current_user)
    # @knote = Knote.new(params[:knote] || nil)
    # @concept = @knote.concepts.empty? ? @knote.concepts.build(:name => "untitled") : @knote.concepts.first

    # @concept = params[:concept] ? @knote.concepts.build(params[:concept]) : @knote.concepts.build(:name => "untitled")
    
    respond_to do |format|
      format.html { render :new }
      format.js   { render :new }
    end
  end

  def edit
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    @knote = @knotebook.knotes.find(params[:id])
    # @knote = Knote.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render :new }
    end
  end

  def create
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    @knote = Knote.build(params[:knote])
    @knote.source = "#{current_user.name}, Knotebooks \"#{@knote.title}\", #{knotebook_url @knotebook}" if params[:knote][:references] == "auto"

    respond_to do |format|
      render :action => 'new' and return if params[:commit] == "Change Knote Type"
      
      if @knote.save
        @knotebook.knotes << @knote
        flash.now[:notice] = "Knote was successfully created."
        format.html { redirect_to edit_knotebook_path(@knotebook) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # TODO: create a new knote if knote.user != current_user
  def update
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    @knote = @knotebook.knotes.find(params[:id])
    
    respond_to do |format|
      if @knote.update_attributes(params[:knote])
        flash.now[:notice] = 'Knote was successfully updated.'
        format.html { redirect_to edit_knotebook_path(@knotebook) }
      else
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    @knote = @knotebook.knotes.find(params[:id])
    
    if @knote.user == current_user
      @knote.destroy if @knote.knotings.size == 1
      flash[:notice] = 'Knote was removed completely and no longer exists.'
    else
      @knotebook.knotes.delete(@knote)
      flash[:notice] = 'Knote was removed from this knotebook, but still exists in other knotebooks.'
    end

    respond_to do |format|
      format.html { redirect_to edit_knotebook_path(@knotebook) }
    end
  end
  
  def restore
    @knotebook = Knotebook.find(params[:knotebook_id])
    @position = params[:position].to_i
    @knote = @knotebook.knotes[@position]

    render :show
  end

  def easier
    @knotebook = Knotebook.everyone(params[:knotebook_id])
    @knote = Knote.find_easier(params)
    @position = params[:position]
    
    if @knote.nil?
      set_knote_flash("easier")
      @knote = Knote.find(params[:id])
    end
    
    render :show
  end
  
  def harder
    @knotebook = Knotebook.everyone(params[:knotebook_id])
    @knote = Knote.find_harder(params)
    @position = params[:position]
    
    if @knote.nil?
      set_knote_flash("harder")
      @knote = Knote.find(params[:id])
    end
    
    render :show
  end
  
  # 
  # def easier
  #   @media_type = params[:media_type] || "any"
  #   @concept_ids = params[:concepts] || []
  #   @knote = Knote.find(params[:id], :include => :concepts).easier!(@concept_ids, @media_type) or raise ActiveRecord::RecordNotFound
  #   @position = params[:position]
  #   @restore = params[:restore]
  #       
  #   respond_to do |format|
  #     # format.html { redirect_to @knote, :status => 303 }
  #     # format.json { redirect_to knote_url(@knote, :format => :json), :status => 303 }
  #     format.json { render :show }
  #   end
  # end
  # 
  # def harder
  #   @media_type = params[:media_type] || "any"
  #   @concept_ids = params[:concepts] || []
  #   @knote = Knote.find(params[:id], :include => :concepts).harder!(@concept_ids, @media_type) or raise ActiveRecord::RecordNotFound
  #   @position = params[:position]
  #   @knotebook = Knotebook.find(params[:knotebook_id])
  #   @restore = params[:restore]
  # 
  #   respond_to do |format|
  #     # format.html { redirect_to @knote, :status => 303 }
  #     # format.json { redirect_to knote_url(@knote, :format => :json), :status => 303 }
  #     format.json { render :show }
  #   end
  # end
  
  # def search_index
  #   @knote = Knote.new
  #   
  #   respond_to do |format|
  #     format.html
  #     format.json
  #   end
  # end

  def search
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])
    if params[:knote_search]
      @search = Knote.search do |query|
        query.keywords params[:knote_search]
        query.paginate(:page => params[:page], :per_page => 1)
      end
      @knotes = @search.results
      @knote = @knotes.first
    end
    @knotes ||= []

    respond_to do |format|
      flash.now[:notice] = 'No knotes found. Please try a different search!' if @knotes.empty?
      format.html { render :search }
      format.js   { render :search }
    end
  end
  
  def add
    @knotebook = current_user.knotebooks.find(params[:knotebook_id])

    respond_to do |format|
      if @knotebook.knotes << Knote.find(params[:id])
        flash.now[:notice] = "Knote was successfully added."
        format.html { redirect_to edit_knotebook_path(@knotebook) }
      else
        flash.now[:error] = "That knote couldn't be added.  Maybe it was deleted?"
        format.html { redirect_to edit_knotebook_path(@knotebook) }
      end
    end
  end
  
  # def search
  #   @concept = Concept.find_by_name(params[:id])
  #   # @knotes = @concept.knotes.sort_by(&:difficulty)
  # 
  #   @knotes = Knote.by_concept([@concept.id]).all(:order => "difficulty ASC, knotes.created_at DESC")
  #   
  #   @knote = @knotes.first or raise ActiveRecord::RecordNotFound
  #   
  #   # @media_type = params[:media_type] || "any"
  # 
  #   # params[:concept_id] = @concept.id
  #   # difficulty = params[:difficulty] || 0
  #   # media_type = params[:media_type] || "any"
  #   # concepts =   params[:concepts]   || []
  #   # 
  #   # @knote = Knote.related(@concept).similar(media_type).except(concepts).first or raise ActiveRecord::RecordNotFound
  #   # 
  #   respond_to do |format|
  #     format.html
  #     # format.html { redirect_to concept_knote_url, :status => 303 }
  #     # format.json { redirect_to concept_knote_url(:format => :json), :status => 303 }
  #   end
  # end
  
  # def search_easier
  #   @concepts = Concept.all(:conditions => { :name => params[:id].split(', ') }, :include => :knotes)
  #   @concept = Concept.find_by_name(params[:id], :include => :knotes)
  #   
  #   difficulty = params[:difficulty] || 0
  #   media_type = params[:media_type] || "any"
  #   concepts =   params[:concepts]   || []
  #   
  #   @knote = Knote.related(@concept).similar(media_type).except(concepts).first or raise ActiveRecord::RecordNotFound
  #   
  #   respond_to do |format|
  #     format.html { render :search }
  #     format.json { render :search }
  #   end
  # end
  # 
  # def search_harder
  #   # @concepts = Concept.all(:conditions => { :name => params[:id].split(', ') }, :include => :knotes)
  #   @concept = Concept.find_by_name(params[:id], :include => :knotes)
  #   
  #   difficulty = params[:difficulty] || 0
  #   media_type = params[:media_type] || "any"
  #   concepts =   params[:concepts]   || []
  #   
  #   @knote = Knote.related(@concept).similar(media_type).except(concepts).first or raise ActiveRecord::RecordNotFound
  #   
  #   respond_to do |format|
  #     format.html { render :search }
  #     format.json { render :search }
  #   end
  # end
  
  private
  
  def set_knote_flash(kind)
    flash.now[:notice] = "We couldn't find #{kind == 'harder' ? 'a harder' : 'an easier'} #{'video ' if params[:knote_type] == 'Video'}knote.  Sorry!"
  end
end