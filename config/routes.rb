Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:show]

  resources :customers

  resources :products, except: [:show]

  resources :orders
  resources :order_items, only: [:create]

  # Defines the root path route ("/")
  # root "articles#index"
end
