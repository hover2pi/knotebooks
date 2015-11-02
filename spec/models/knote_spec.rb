require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Knote do
  it "should find easier knotes if they exist" do
    user = User.make
    hard = Knote.make(:difficulty => 1, :user => user)
    easy = Knote.make(:difficulty => 0, :user => user)
    hard.easier.should == easy
    Knote.easier(hard).should == [easy]
    Knote.easier(1).should == [easy]
  end
  
  it "should find harder knotes if they exist" do
    user = User.make
    hard = Knote.make(:difficulty => 1, :user => user)
    easy = Knote.make(:difficulty => 0, :user => user)
    easy.harder.should == hard
    Knote.harder(easy).should == [hard]
    Knote.harder(0).should == [hard]
  end
  
  it "should delete associated knotings if deleted" do
  end
end
