class AddIndexesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_index :orders, :status
    add_index :orders, :paid
    add_index :orders, :delivery_date
    add_index :orders, :created_at
    add_index :orders, :town
    add_index :orders, :postcode
  end
end
