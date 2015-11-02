require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KnotebooksHelper do

  #Delete this example and add some real ones or delete this file
  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(KnotebooksHelper)
  end

end

def make_knotebook_with_knotes(attributes = {})
  Knotebook.make(attributes) do |knotebook|
    3.times { knotebook.knotes.make }
  end
end