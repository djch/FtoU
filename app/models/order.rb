class Order < ApplicationRecord
  include Addressable

  belongs_to :customer
  has_many :order_items, dependent: :destroy, inverse_of: :order
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  # Validation for the status field
  validates :status, presence: true, inclusion: { in: %w(pending confirmed cancelled delivered) }
  validates :delivery_date, presence: true

  # Callback to copy address from the associated customer
  before_create :copy_customer_address

  def price
    order_items.sum(&:total_price)
  end

  def total_price
    price + delivery_fee
  end

  private

    def copy_customer_address
      self.street_address = customer.street_address
      self.town           = customer.town
      self.state          = customer.state
      self.postcode       = customer.postcode
      self.country        = customer.country
    end
end