require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KnotebooksController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "knotebooks", :action => "index").should == "/knotebooks"
    end

    it "maps #new" do
      route_for(:controller => "knotebooks", :action => "new").should == "/knotebooks/new"
    end

    it "maps #show" do
      route_for(:controller => "knotebooks", :action => "show", :id => "1").should == "/knotebooks/1"
    end

    it "maps #edit" do
      route_for(:controller => "knotebooks", :action => "edit", :id => "1").should == "/knotebooks/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "knotebooks", :action => "create").should == {:path => "/knotebooks", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "knotebooks", :action => "update", :id => "1").should == {:path =>"/knotebooks/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "knotebooks", :action => "destroy", :id => "1").should == {:path =>"/knotebooks/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/knotebooks").should == {:controller => "knotebooks", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/knotebooks/new").should == {:controller => "knotebooks", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/knotebooks").should == {:controller => "knotebooks", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/knotebooks/1").should == {:controller => "knotebooks", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/knotebooks/1/edit").should == {:controller => "knotebooks", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/knotebooks/1").should == {:controller => "knotebooks", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/knotebooks/1").should == {:controller => "knotebooks", :action => "destroy", :id => "1"}
    end
  end
end
