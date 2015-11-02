class Concept < ActiveRecord::Base
  CONCEPT_DELIMITER = ", "
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[^[:cntrl:]]+$/, :on => :create, :message => "must not have special characters"
  
  has_many_polymorphs :conceptualizables, 
    :from => [:knotebooks, :knotes, :concepts], 
    :through => :conceptualizations,
    :as => :topic,
    :parent_extend => proc {
      def to_s
        self.map(&:name).sort.join(CONCEPT_DELIMITER)
      end
    }

  default_scope :include => :conceptualizations

  class Error < StandardError
  end
  
  def before_save
    self.name.downcase!
  end
end
