class Video < Knote
  attr_accessible :start_time, :end_time, :url, :caption
  
  validates_format_of :url, :with => /^(http:\/\/)?(www\.)?youtube\.com\/watch\?v=[_a-zA-Z0-9-]{11}.*$/ix, :message => "doesn't look like a YouTube URL"
  validates_presence_of :caption
  validates_format_of :start_time, :with => /^(\d+|:)+$/, :allow_blank => true, :message => "is not a timecode (1:32 or 92)"
  validates_format_of :end_time, :with => /^(\d+|:)+$/, :allow_blank => true, :message => "is not a timecode (1:32 or 92)"
  validate :validate_end_before_start
  validates_length_of :caption, :maximum => 500, :allow_blank => true
  
  def validate_end_before_start
    if seconds_from(end_time) <= seconds_from(start_time)
      errors.add(:end_time, "must be greater than the start time or left blank") unless end_time.blank?
    end
  end
  
#####################################################################################
#  HELPER METHODS                                                                   #
#####################################################################################
  
  def video_id
    doc = Hpricot.parse(url)
    
    embed_url = if(element = doc % "//param[@name='movie']")
      element.attributes["value"]
    elsif (element = doc % "//embed")
      element.attributes["src"]
    end
    
    if embed_url && (match = %r{/v/(\w+)&}.match(embed_url))
      return match[1]
    end
    
    query_string = url.split('?',2)[1]
    if query_string
      params = CGI.parse(query_string)
      if params.has_key?("v")
        return params["v"][0]
      end  
    end
  end
  
  def start_at
    unless start_time.nil? || start_time.blank?
      "&start=#{seconds_from(start_time)}"
    end
  end
  
  def end_at
    seconds_from(end_time) unless start_time.nil? || start_time == 0
  end
  
  def seconds_from(val)
    val.to_s.split(":").reverse.map(&:to_i).each_with_index.collect{|x,i| x*60**i}.sum
  end
end
