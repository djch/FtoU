class ChangeDefaultDeliveryFeeInOrders < ActiveRecord::Migration[7.0]
  def up
    change_column_default :orders, :delivery_fee, nil

    # Optionally, update existing records with the old default to nil:
    # Order.where(delivery_fee: 50.0).update_all(delivery_fee: nil)
  end

  def down
    change_column_default :orders, :delivery_fee, 50.0
  end
end
