class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :set_price

  def live_price
    @live_price ||= self.price || product.price * quantity
  end

  def set_price
    self.price ||= product.price * quantity
  end
end
