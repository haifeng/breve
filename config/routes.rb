ActionController::Routing::Routes.draw do |map|
  map.login     'login',           :controller => 'users', :action => 'login'
  map.logout    'logout',          :controller => 'users', :action => 'logout'
  map.reset     'reset',           :controller => 'users', :action => 'reset'
  map.settings  'settings',        :controller => 'users', :action => 'edit'
  map.documents 'documents/:name', :controller => 'main',  :action => 'view'

  map.resources :posts, 
    :member     => { :comment => :post, :vote => :post }, 
    :collection => { :latest => :get, :hot => :get } do |posts|
      posts.resources :comments, :member => { :reply => [ :get, :post ], :vote => :post }
    end
  
  map.resources :comments, 
    :has_many   => :comments, 
    :member     => { :reply => [ :get, :post ], :vote => :post, :replies => :get },
    :collection => { :hot => :get }
  
  map.resources :users do |users| 
    users.resources :posts,    :collection => { :submitted => :get, :voted => :get }
    users.resources :comments, :collection => { :submitted => :get, :voted => :get }
  end

  map.root :controller => 'posts'
end
