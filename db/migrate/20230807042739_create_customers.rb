class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string "first_name", null: false
      t.string "last_name", null: false
      t.string :phone
      t.string :email
      t.string :street_address
      t.string :town
      t.string :state
      t.string :postcode
      t.string :country
      t.text :delivery_notes

      t.timestamps
    end
  end
end
