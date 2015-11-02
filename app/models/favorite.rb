class Favorite < Knotebook
  attr_accessor :original_id
  
  belongs_to :original, :class_name => "Knotebook", :foreign_key => "original_id"
  
  default_scope :include => [:user, :knotings, :knotes], :conditions => { :knotebook_type => "Favorite" }
end