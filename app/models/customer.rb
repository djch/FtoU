class Customer < ApplicationRecord
  include Addressable
  include PgSearch::Model

  pg_search_scope :search_by_name, against: [:first_name, :last_name], using: { tsearch: { prefix: true } }
  has_person_name

  has_many :orders

  validates :phone, presence: true
end
