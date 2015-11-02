module KnotesHelper
  def gimeo(knote)
    if vid = knote.video_id
      render :partial => "knotes/video", :object => knote, :locals => { :vid => vid }
    else
      "Error: We couldn't find that video!"
    end
  end
end
