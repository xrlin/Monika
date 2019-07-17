Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "flow#index"
  resources :articles
  resources :posts
  resources :comments, only: [:index, :destroy, :create]
  resources :users, except: [:index, :destroy]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :votes, only: [:create]
end
