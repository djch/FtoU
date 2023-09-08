Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:show]

  resources :customers

  resources :products, except: [:show]

  resources :orders
  resources :order_items, only: [:create, :destroy]
  delete 'order_items/by_product/:product_id', to: 'order_items#destroy', as: 'destroy_order_item_by_product'

  # Defines the root path route ("/")
  # root "articles#index"
end
