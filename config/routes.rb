ActionController::Routing::Routes.draw do |map|
  map.resources :statistical_areas, :collection => { :status => :get }
  map.root :controller => :statistical_areas, :action => :index
end
