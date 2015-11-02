class KnotebooksController < ApplicationController
  # before_filter :require_valid_user, :except => [:index, :show, :search]
  before_filter :require_user, :except => [:index, :show, :search]
  
  def index
    @concepts = Knote.count(:joins => :concepts, :group => "concepts.name", :order => "count_all DESC", :limit => 10).sort{ |a,b| b.last <=> a.last }.map{|x| x.first }
    @knotebooks = Knotebook.paginate(:page => params[:page], :order => 'updated_at DESC', :per_page => 10)
    @index_text = "All Knotebooks"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lessons }
    end
  end
  
  def search
    @search = Knotebook.search do |query|
      query.keywords params[:search]
      query.paginate(:page => params[:page], :per_page => 10)
      query.with(:knotebook_type).equal_to("Knotebook")
    end
    @knotebooks = @search.results
    @concepts = Knote.count(:joins => :concepts, :group => "concepts.name", :order => "count_all DESC", :limit => 10).sort{ |a,b| b.last <=> a.last }.map{|x| x.first }
    
    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @lessons }
    end
  end

  def show
    @knotebook = Knotebook.find(params[:id], :include => { :comments => :user })
    @comments = @knotebook.comments
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @knotebook }
    end
  end

  def new
    @knotebook = current_user.knotebooks.build
  end

  def create
    @knotebook = current_user.knotebooks.build(params[:knotebook])
    # @knotebook.knotes.map { |k| k.user = User.first if k.user.nil? }

    respond_to do |format|
      if @knotebook.save
        flash.now[:notice] = 'Knotebook was successfully created. Add a new knote or search for existing knotes.'
        format.html { redirect_to edit_knotebook_path(@knotebook) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @knotebook = current_user.knotebooks.find(params[:id])
  end

  def update
    @knotebook = current_user.knotebooks.find(params[:id])

    respond_to do |format|
      if @knotebook.update_attributes(params[:knotebook])
        flash[:notice] = 'Knotebook was successfully updated.'
        format.html { redirect_to(@knotebook) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @knotebook = current_user.knotebooks.find(params[:id])
    @knotebook.destroy
    flash[:notice] = "Knotebook was successfully deleted."
    
    respond_to do |format|
      format.html { redirect_to(knotebooks_url) }
    end
  end
  
  def sort
    @knotebook = Knotebook.find(params[:id])
    @knotebook.knotings.each do |k|
      k.update_attribute(:position, params[:knote].index(k.knote_id.to_s) + 1)
    end
    render :nothing => true
  end
  
  def favorite
    @knotebook = Knotebook.find(params[:id])
    @favorite = current_user.favorites.find(params[:id]) || @knotebook.build_favorite(:user => current_user)
    
    if @favorite.save
      redirect_to [current_user, @favorite]
    end
  end
  
  def ignore
    if [1,2].include?(current_user.id)
      Knotebook.find(params[:id]).update_attribute(:ignore, true)
      flash[:notice] = "Knotebook is now hidden"
      redirect_to knotebooks_url
    end
  end

  def feature
    if [1,2].include?(current_user.id)
      Knotebook.find(params[:id]).update_attribute(:featured, true)
      flash[:notice] = "Knotebook is now featured"
      redirect_to knotebooks_url
    end
  end
end