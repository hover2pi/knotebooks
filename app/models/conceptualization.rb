class Conceptualization < ActiveRecord::Base
  belongs_to :topic, :class_name => "Concept", :foreign_key => "topic_id"
  belongs_to :conceptualizable, :polymorphic => true
  
  validates_uniqueness_of :topic_id, :scope => [:conceptualizable_id, :conceptualizable_type], :message => "already exists"
  
  def after_destroy
    topic.destroy_without_callbacks if topic and topic.conceptualizations.count == 0
  end
end
