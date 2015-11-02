class Html < Knote
  attr_accessible :content
  
  validates_presence_of :content
end