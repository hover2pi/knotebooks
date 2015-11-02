require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Knoting do
  before(:each) do
    @valid_attributes = {
      :knotebook_id => 1,
      :knote_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Knoting.create!(@valid_attributes)
  end
end
