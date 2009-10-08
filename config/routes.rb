ActionController::Routing::Routes.draw do |map|  # controller for 
  map.identity_login    ':provider/login',    :controller => 'identity_consumer', :action => 'login'
  map.identity_callback ':provider/callback', :controller => 'identity_consumer', :action => 'callback'
  
  map.login       'login',           :controller => 'users', :action => 'login'
  map.logout      'logout',          :controller => 'users', :action => 'logout'
  map.reset       'reset',           :controller => 'users', :action => 'reset'
  map.activation  'activate',        :controller => 'users', :action => 'activate'
  map.settings    'settings',        :controller => 'users', :action => 'edit'
  map.documents   'documents/:name', :controller => 'main',  :action => 'view'

  map.namespace :admin do |admin|
    map.admin 'admin/', :controller => 'main'
    admin.resources :users
  end

  map.resources :posts, 
    :member     => { :comment => :post, :vote => :post }, 
    :collection => { :top_ranked => :get, :latest => :get, :voted_by => :get } do |posts|
                     posts.resources :comments, :member => { :reply => [ :get, :post ], :vote => :post }
                   end
  
  map.resources :comments, 
    :has_many   => :comments, 
    :member     => { :reply => [ :get, :post ], :vote => :post, :replies => :get },
    :collection => { :top_ranked => :get }
  
  map.resources :users do |users| 
    users.resources :posts,    :collection => { :submitted => :get, :voted => :get }
    users.resources :comments, :collection => { :submitted => :get, :voted => :get }
  end

  map.root :controller => 'posts', :action => 'top_ranked'
end
