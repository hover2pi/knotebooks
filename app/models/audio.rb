class Audio < Knote
  attr_accessible :start_time, :end_time, :url, :caption
  attr_accessor :concepts_list
  
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix, :message => "doesn't look like a URL"
  validate :validate_start, :validate_end
  
  def validate_start
    unless start_time.nil? || start_time.blank?
      errors.add(:start_time, "is not valid") unless start_time =~ /[0-9]*:?[0-9]+/
    else
      true
    end
  end
  
  def validate_end
    unless end_time.nil? || end_time.blank?
      errors.add(:end_time, "is not valid") unless end_time.to_s =~ /[0-9]*:?[0-9]+/
    else
      true
    end
    if end_time.to_s <= start_time.to_s
      errors.add(:end_time, "must be greater than the start time or left blank") unless end_time.to_s.blank?
    end
  end
end
