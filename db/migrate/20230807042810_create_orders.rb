class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :status
      t.datetime :delivery_date
      t.string :street_address
      t.string :town
      t.string :state
      t.string :postcode
      t.string :country
      t.text :notes

      t.timestamps
    end
  end
end
