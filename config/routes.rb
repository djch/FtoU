Rails.application.routes.draw do

  # Users (Staff)
  devise_for :users
  resources :users, except: [:show]

  # Customers
  resources :customers

  # Products
  resources :products, except: [:show]

  # Orders
  resources :orders
  resources :order_items, only: [:create, :destroy]
  delete 'order_items/by_product/:product_id', to: 'order_items#destroy', as: 'destroy_order_item_by_product'
  get 'orders/:id/confirmation_preview', to: 'orders#confirmation_preview', as: :confirmation_preview

  # Schedule
  get 'deliveries', to: 'deliveries#index', as: :deliveries
  get 'deliveries/sheets', to: 'deliveries/sheets#index', as: :delivery_sheets
  get 'deliveries/sheets/:id', to: 'deliveries/sheets#show', as: :delivery_sheet

  # The root path route ("/")
  root "orders#new"
end
