require 'tempfile'

# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Latex
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/images\/latex/
      tex = CGI.unescape env["PATH_INFO"].split('/', 4)[3]
      if tex =~ /^inline\//
        tex = '$' + tex.split('/',2)[1] + '$'
      else
        tex = '\[' + tex + '\]'
      end
      if l2p(tex, "#{tex}.png")
        [200, {"Content-Type" => "image/png"}, File.open(RAILS_ROOT + "/foo.png")]
      else
        [500, {"Content-Type" => "text/html"}, ["Didn't work :("]]
      end
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
  
  def self.l2p(tex, outfile)
    system File.dirname(__FILE__) + "/../../../l2p/l2p", '-p', 'amssymb,amsmath', '-i', tex, '-d', '120', '-o', 'foo.png'
  end
end
