class AddReceiveOrderNotificationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :receive_order_notifications, :boolean, default: false
  end
end
