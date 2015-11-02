ActionController::Routing::Routes.draw do |map|
  map.resources :posts
  
  map.login     '/login',      :controller => :user_sessions, :action => :new
  map.rpx_login '/login/rpx',  :controller => :user_sessions, :action => :create
  map.logout    '/logout',     :controller => :user_sessions, :action => :destroy
  # map.register  '/register',   :controller => :users,         :action => :new
  map.authorize '/users/:id/authorize', :controller => :users, :action => :authorize, :method => :post
  map.resources :user_sessions

  map.forgot '/forgot', :controller => 'users', :action => 'forgot'

  map.root :controller => 'pages'
  map.pages ':page', :controller => 'pages', :action => :show, :page => PagesController::PAGES

  map.resources :users do |user|
    user.resources :knotebooks, :only => :index
    user.resources :comments, :only => [:create, :destroy]
    user.resources :favorites, :only => [:show, :update]
  end

  map.resources :knotebooks, :collection => { :search => :get }, :member => { :sort => :post, :ignore => :get, :feature => :get } do |kb|
    kb.resources :comments, :only => [:create, :destroy]
    kb.resources :knotes, :collection => { :search => :get }, :member => { :easier => :get, :harder => :get, :restore => :get }
    kb.add_knotebook_knote 'knotes/add/:id', :controller => :knotes, :action => :add, :name_prefix => nil, :method => :post
    # kb.resources :favorites, :only => [:create, :update], :update => :any
  end
  
  map.create_favorite '/knotebooks/:knotebook_id/favorite', :controller => :favorites, :action => :create, :method => :post
  # map.update_favorite '/users/:user_id/favorites/:id', :controller => :favorites, :action => :update, :method => [:post, :put]
  
  map.resources :knotes, :only => :show
  map.with_options :controller => 'knotes' do |knote|
    knote.harder         '/knotes/:id/harder.format',         :action => :harder
    knote.easier         '/knotes/:id/easier.format',         :action => :easier
    knote.search_knotes  '/knotes/about.:format',             :action => :search_index
    knote.search_knote   '/knotes/about/:id.:format',         :action => :search
    knote.concept_knotes '/concept/:id/knotes/:page.:format', :action => :index
    knote.easier_about   '/knotes/about/:id/easier.:format',  :action => :search_easier
    knote.harder_about   '/knotes/about/:id/harder.:format',  :action => :search_harder
  end
  
  map.resources :concepts
  
  map.connect '/javascripts/:action.js', :controller => 'javascripts', :only => [:application, :new, :swap]
end
