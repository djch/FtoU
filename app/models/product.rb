class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  has_one_attached :image
  has_rich_text :description

  validates :title, presence: true
  validates :unit, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :by_price, -> { order(price: :desc) }
end
