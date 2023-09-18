Rails.application.routes.draw do
  get 'deliveries/index'
  devise_for :users
  resources :users, except: [:show]

  resources :customers

  resources :products, except: [:show]

  resources :orders
  resources :order_items, only: [:create, :destroy]
  delete 'order_items/by_product/:product_id', to: 'order_items#destroy', as: 'destroy_order_item_by_product'
  get 'orders/:id/confirmation_preview', to: 'orders#confirmation_preview', as: :confirmation_preview

  resources :deliveries, only: [:index]

  # Defines the root path route ("/")
  # root "articles#index"
end
