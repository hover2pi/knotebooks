# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    current_user
  end
  
  def time(t)
    if t > 60.seconds.ago
      "< a minute ago"
    elsif t > 7.days.ago
      time_ago_in_words(t) + " ago"
    elsif t > 6.months.ago
      t.strftime "%d %b"
    else
      t.strftime "%d %b %Y"
    end
  end
  
  def difficulty(user)
    case (user.difficulty * 100).floor.to_i
      when 0..24: "General"
      when 25..49: "High School"
      when 50..74: "Undergraduate"
      when 75..99: "Graduate+"
      when 100: "Ninja"
    end
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def license_image_tag(knote)
    image_tag("/images/#{knote.license}.png" || "/images/CCBYNCSA.png")
  end
  
  def kb_url(knotebook)
    knotebook.class == Knotebook ? knotebook_url(knotebook) : user_favorite_url(knotebook.user, knotebook)
  end
  
  def link_to_button(link_text, url, options={})
    link_to content_tag(:button, link_text, :type => "button"), url, options
  end
  
  def link_to_ajax(link_text, url, options={})
    link_to link_text, url, options.reverse_merge!({ :rel => "nofollow", :class => "ajax" })
  end
  
  def link_to_void
    link_to '', "javascript:void(0)"
  end
  
  def link_to_concepts(concepts, options={})
    content_tag :ol, :class => "concept_index" do
      acc = []
      for concept in concepts do
        acc << content_tag(:li, link_to(concept, search_knotebooks_path(:search => concept)), :class => "concept_li")
      end
      acc
    end
  end
  
  def generate_search_header(params, count)
    from = ((params[:page] || 1).to_i - 1) * 10 + 1
    to = from + 9 > count ? count : from + 9
    count.zero? ? "None Found" : "Displaying #{from} - #{to} of #{count} Results"
  end
end