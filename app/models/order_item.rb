class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_save :set_price

  private

    def set_price
      self.price = product.price * quantity
    end
end
