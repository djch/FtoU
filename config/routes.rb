Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:show]

  resources :customers
  resources :products

  # Defines the root path route ("/")
  # root "articles#index"
end
