Rails.application.routes.draw do
	resources :users, :only => [:index, :show]

  root to: 'visitors#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

	get '/user/:id/show_to_read_shelf' => 'users#show_to_read_shelf', :as => :show_to_read_shelf
end
