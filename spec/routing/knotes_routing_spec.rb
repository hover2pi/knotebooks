require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KnotesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "knotes", :action => "index").should == "/knotes"
    end

    it "maps #new" do
      route_for(:controller => "knotes", :action => "new").should == "/knotes/new"
    end

    it "maps #show" do
      route_for(:controller => "knotes", :action => "show", :id => "1").should == "/knotes/1"
    end

    it "maps #edit" do
      route_for(:controller => "knotes", :action => "edit", :id => "1").should == "/knotes/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "knotes", :action => "create").should == {:path => "/knotes", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "knotes", :action => "update", :id => "1").should == {:path =>"/knotes/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "knotes", :action => "destroy", :id => "1").should == {:path =>"/knotes/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/knotes").should == {:controller => "knotes", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/knotes/new").should == {:controller => "knotes", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/knotes").should == {:controller => "knotes", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/knotes/1").should == {:controller => "knotes", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/knotes/1/edit").should == {:controller => "knotes", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/knotes/1").should == {:controller => "knotes", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/knotes/1").should == {:controller => "knotes", :action => "destroy", :id => "1"}
    end
  end
end
