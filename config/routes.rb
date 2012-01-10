Zillow1::Application.routes.draw do
  resources :statistical_areas do
    collection do
      get :status
    end
  end
  root :to => 'statistical_areas#index'
end
