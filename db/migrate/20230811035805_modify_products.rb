class ModifyProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :unit, :string
    add_column :products, :available, :boolean, default: true

    # Remove existing description column, as Action Text will replace it
    remove_column :products, :description
  end
end
