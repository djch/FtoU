class AddDeliveryFeeAndPaidToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :delivery_fee, :decimal, precision: 10, scale: 2, default: 50.0
    add_column :orders, :paid, :boolean, default: false
  end
end
