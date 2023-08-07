class Customer < ApplicationRecord
  include Addressable
  has_many :orders
end
