Refraction.configure do |req|
  req.permanent!("#{req.scheme}://knotebooks.com#{req.path}#{req.query}") if req.host != "knotebooks.com"
end