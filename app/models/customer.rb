class Customer < ApplicationRecord
  include Addressable
  has_many :orders

  has_person_name

  validates :phone, presence: true
end
