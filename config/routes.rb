Zillow1::Application.routes.draw do
  resources :statistical_areas, :collection => { :status => :get }
  root :to => 'statistical_areas#index'
end
