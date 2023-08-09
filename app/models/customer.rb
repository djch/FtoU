class Customer < ApplicationRecord
  include Addressable
  has_many :orders

  validates :name, presence: true
  validates :phone, presence: true
end
