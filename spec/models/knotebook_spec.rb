require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Knotebook do
  before(:each) do
    @kb = Knotebook.make
  end

  it "should create a new instance given valid attributes" do
    Knotebook.make.should be_valid
  end
end