class Knotebook < ActiveRecord::Base
  belongs_to :user
  has_many :knotings, :order => :position, :dependent => :destroy
  has_many :knotes, :through => :knotings, :order => 'knotings.position', :before_add => :set_knote_user
  # has_many :conceptualizations
  # has_many :concepts, :through => :conceptualizations, :source => :topic
  has_many :comments, :as => :commentable
  has_many :favorites, :foreign_key => :original_id
  
  self.inheritance_column = "knotebook_type"
  
  validates_length_of :title, :within => 3..80
  validates_length_of :abstract, :within => 10..400
  
  # validates_presence_of :knotes
  validates_presence_of :title, :abstract
  
  # accepts_nested_attributes_for :knotes, :reject_if => :all_blank
  
  default_scope :include => [:user, :knotings, :knotes], :conditions => { :knotebook_type => "Knotebook", :ignore => false }
  
  named_scope :featured, :conditions => { :featured => true }
  
  def self.everyone(whom)
    with_exclusive_scope { find(whom || :all) }
  end
  
  searchable do
    text :title, :boost => 8
    text :abstract, :boost => 7
    # text :author, :boost => 4 do
    #   user.login
    # end
    
    text :subtitle, :boost => 6 do
      knotes.map &:title
    end

    text :content, :boost => 5 do
      knotes.map &:content
    end
    
    text :concept, :boost => 10 do
      knotes.map &:concepts_list
    end
    
    string :knotebook_type
  end
  
  def self.model_name
    name = ActiveSupport::ModelName.new "knotebook"
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
    end
    return name
  end
  
  def build_favorite(knote_ids=[], options={})
    favorite = self.favorites.build(options.merge attributes)
    knotes = Knote.find(knote_ids)
    favorite.knotes = knote_ids.inject([]){|res,val| res << knotes.detect {|k| k.id == val.to_i }}
    favorite
  end
  
  def build_knote
    if !knotes.empty? && knotes.last.new_record?
      knotes.last
    else
      knotes.build
    end
  end
  
  def set_knote_user(knote)
    if knote.user.nil?
      knote.new_record? ? knote.user_id = user_id : knote.update_attribute(:user_id, user_id)
    end
  end
  
  def self.all_of_dems(id)
    with_exclusive_scope { find(id) }
  end
  
  def add_topics(*args)
    args.each do |arg|
      arg = arg.split(Concept::CONCEPT_DELIMITER) if arg.is_a? String
      arg.each do |topic|
        topic = Concept.find_or_create_by_name(topic)
        topics << topic unless topics.index(topic)
      end
    end
  end
  
  def original
    Knotebook.find(original_id)
  end
  
  def concepts_list
    self.knotes.map(&:concepts).flatten.uniq.map(&:name)
  end
  
  def concepts
    concepts_list.join(Concept::CONCEPT_DELIMITER)
  end
    
  def topics
    topics_list.join(', ')
  end
  
  def topics_list
    topics.collect(&:name)
  end

  # def concepts_list
  #   knotes.collect(&:concepts_list).flatten.uniq
  # end
  # 
  # def set_concepts
  #   tags.each do |t|
  #     t.tags knotes.collect(&:tags).flatten.uniq
  #   end
  # end
  # 
  # def add_concept(concept)
  #   tags.each do |t|
  #     t._add_tags concept
  #   end
  # end
  
  def self.to_fixture
    File.open(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT), "w") do |file|
      file << self.find(:all).inject("---\n") do |s, record|
        self.columns.inject(s+"#{record.id}:\n") do |s, c|
          s+"  #{{c.name => record.attributes[c.name]}.to_yaml[5..-1]}"
        end
      end
    end
  end
  
  def author
    self.user.name
  end
end
