class AddPriceToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :price, :decimal, precision: 10, scale: 2
  end
end
