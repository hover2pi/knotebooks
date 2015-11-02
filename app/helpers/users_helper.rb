module UsersHelper
  def knotebooks_list(user)
    user.knotebooks.all(:limit => 3).collect do |kb|
      content_tag(:li, (link_to kb.title, kb))
    end
  end
  
  def grabatar_for(user, options={})
    if user.is_org?
      gimmie_dat!(user.logo, options)
    else
      gravatar(user.email || "foo@bar.com", options)
    end
  end
end
