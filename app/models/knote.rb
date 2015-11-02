class Knote < ActiveRecord::Base
  attr_accessible :title, :license, :user_id, :source, :difficulty, :content_type, :concepts_list, :references
  attr_accessor :concepts_list, :references
  cattr_reader :per_page
  @@per_page = 1

  # KNOTE_TYPES = subclasses.map(&:to_s).sort
  KNOTE_TYPES = %w{Html Video}
  CONTENT_TYPES = %w{Explanation Introduction Definition Proof Problem Demonstration}

  belongs_to :user
  has_many :knotings, :dependent => :destroy
  has_many :knotebooks, :through => :knotings, :after_add => :tag_knotebooks
  has_many :conceptualizations
  has_many :concepts, :through => :conceptualizations, :source => :topic

  self.inheritance_column = "knote_type"
  
  before_save :spunge_difficulty
  # before_validation_on_create :generate_references

  # default_scope :order => 'difficulty ASC, knotes.created_at DESC', :include => [:user, :concepts, :knotings, :knotebooks, :concepts]

  named_scope :harder_than, lambda { |d,i| { :conditions => ["knotes.difficulty > ? AND knotes.id NOT IN (?)", d, i], :order => "knotes.difficulty ASC, knotes.created_at DESC" } }
  named_scope :easier_than, lambda { |d,i| { :conditions => ["knotes.difficulty < ? AND knotes.id NOT IN (?)", d, i], :order => "knotes.difficulty DESC, knotes.created_at DESC" } }
  named_scope :related_to, lambda { |i| { :joins => :concepts, :conditions => ["concepts.id IN (?)", i] } }
  named_scope :by_concepts, lambda { |ids| { :joins => :concepts, :conditions => ["concepts.id IN (?)", ids] } }
  named_scope :by_concept_names, lambda { |names| { :joins => :concepts, :conditions => ["concepts.name IN (?)", names] } }

  validates_length_of :title, :within => 3..80
  validates_presence_of :source, :content_type, :knote_type, :difficulty, :concepts_list
  validates_inclusion_of :knote_type, :in => KNOTE_TYPES, :on => :create, :message => "{{value}} is not a valid Knote type"
  validates_inclusion_of :content_type, :in => CONTENT_TYPES.map(&:downcase), :on => :create, :message => '"{{value}}" is not a valid Content type'
  validates_numericality_of :difficulty, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  searchable do
    text :concepts_list, :boost => 10
    text :title, :boost => 8
    text :content, :boost => 7
  end
  
  def self.model_name
    name = ActiveSupport::ModelName.new "knote"
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
    end
    return name
  end
  
  def self.select_options(extra=nil)
    # subclasses.map(&:to_s).sort.unshift(extra).compact
    # %w[Html Audio Video].unshift(extra).compact
    %w[Html Video].unshift(extra).compact
  end
  
  def self.content_select_options
    CONTENT_TYPES.map { |c| [c, c.downcase] }
  end
  
  def self.difficulty_select_options(difficulty=nil)
    options = ["General", "High School", "Undergrad", "Graduate+"]
    options.map!.with_index { |d, i| [d, (100.0 / options.size / 2) + i * (100.0 / options.size)] }
    difficulty.nil? ? options : options << ['-', difficulty]
  end
  
  def self.build(params)
    type = params.delete :knote_type
    if select_options.include? type.classify
      type.classify.constantize.new(params)
    else
      self.new(params)
    end
  end
  
#####################################################################################
#                                   HELPER METHODS                                  #
#####################################################################################
  
  # def generate_references
  #   if references == "auto"
  #     self.source = "THIS IS AUTO-GENERATED!"
  #   end
  # end
  
  def self.find_harder(params)
    k = find(params[:id])
    ids = Knote.all(:select => "knotes.id", :joins => :knotebooks, :conditions => ["knotebooks.id = ?", params[:knotebook_id]]).map(&:id)
    ids << params[:id].to_i
    ids.delete_at params[:position].to_i
    harder_than(k.difficulty, ids).related_to(k.concept_ids)
    type = params[:knote_type] == "Any" ? KNOTE_TYPES : params[:knote_type]
    first(:joins => :concepts, :conditions => ["knotes.difficulty > ? AND knotes.id NOT IN (?) AND concepts.id IN (?) AND knotes.knote_type IN (?)", k.difficulty, ids, k.concept_ids, type], :order => "knotes.difficulty ASC, knotes.created_at DESC")
    # first(:conditions => ["difficulty > ? AND id NOT IN (?)", k.difficulty, ids], :order => "difficulty ASC").related_to
  end
  
  def self.find_easier(params)
    k = find(params[:id])
    ids = Knote.all(:select => "knotes.id", :joins => :knotebooks, :conditions => ["knotebooks.id = ?", params[:knotebook_id]]).map(&:id)
    ids << params[:id].to_i
    ids.delete_at params[:position].to_i
    type = params[:knote_type] == "Any" ? KNOTE_TYPES : params[:knote_type]
    first(:joins => :concepts, :conditions => ["knotes.difficulty < ? AND knotes.id NOT IN (?) AND concepts.id IN (?) AND knotes.knote_type IN (?)", k.difficulty, ids, k.concept_ids, type], :order => "knotes.difficulty DESC, knotes.created_at DESC")
    # first(:conditions => ["difficulty < ? AND id NOT IN (?)", k.difficulty, ids], :order => "difficulty DESC")
  end
  
  def harder
    Knote.first :joins => :concepts, :conditions => ["knotes.difficulty < ? AND knotes.id != ? AND concepts.id IN (?)", difficulty, id, concepts], :order => "difficulty DESC"
  end
  
  def easier
    Knote.first :joins => :concepts, :conditions => ["knotes.difficulty > ? AND knotes.id != ? AND concepts.id IN (?)", difficulty, id, concepts], :order => "difficulty ASC"
  end
  
  # def easier(ids=[], *type)
  #   type.delete_if { |t| !MEDIA_TYPES.include? t}
  #   type = ["any"] if type.empty? or type.nil?
  #   ids << id
  #   Knote.related(concept_ids).easier(difficulty).similar(type).except(ids)
  # end
  # 
  # def easier!(*type)
  #   self.easier(*type).first
  # end
  # 
  # def harder(ids=[], *type)
  #   type.delete_if { |t| !MEDIA_TYPES.include? t }
  #   type = ["any"] if type.empty? || type.nil?
  #   ids << id
  #   Knote.related(concept_ids).harder(difficulty).similar(type).except(ids)
  # end
  # 
  # def harder!(*type)
  #   self.harder(*type).first
  # end
  # 
  # def similar
  #   Knote.similar(media_type)
  # end
  # 
  # def related
  #   Knote.related(concept_ids)
  # end
  
  def add_concepts(*args)
    args.each do |arg|
      arg = arg.split(Concept::CONCEPT_DELIMITER) if arg.is_a? String
      arg.each do |concept|
        concept = Concept.find_or_create_by_name(concept)
        self.concepts << concept unless self.concepts.index(concept)
      end
    end
  end
  
  def concept_id=(num)
    self.concepts.clear
    self.concepts << Concept.find(num)
  end
  
  def concept=(name)
    self.concepts.clear
    self.concepts << Concept.find_by_name(name)
  end
  
  def related_concepts_list
    knotebooks.map(&:concepts_list).flatten.uniq - concepts.map(&:name)
  end
  
  def related_concepts
    related_concepts_list.join(Concept::CONCEPT_DELIMITER)
  end

  def concept
    concepts.first
  end
  
  def concept_ids
    concepts.map &:id
  end
  
  def concepts_list
    concepts.collect(&:name).join(', ')
  end
  
  def concepts_list=(names)
    self.concepts.clear
    self.concepts << Concept.find_or_create_by_name(names.split(Concept::CONCEPT_DELIMITER).first)
    # add_concepts(*names)
  end
  
  def spunge_difficulty
    self.difficulty += rand / 100
  end
  
  # def self.to_fixture
  #   File.open(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT), "w") do |file|
  #     file << self.find(:all).inject("---\n") do |s, record|
  #       self.columns.inject(s+"#{record.id}:\n") do |s, c|
  #         s+"  #{{c.name => record.attributes[c.name]}.to_yaml[5..-1]}"
  #       end
  #     end
  #   end
  # end
end