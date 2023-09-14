class AddExtraCustomerDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :company_name, :string
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phone, :string
  end
end
