class Customer < ApplicationRecord
  include Addressable
  include MailchimpSyncable
  include PgSearch::Model

  pg_search_scope :search_by_name, against: [:first_name, :last_name], using: { tsearch: { prefix: true } }
  has_person_name

  has_many :orders

  validates :first_name, presence: { message: "and last name are required." }
  validates :last_name, presence: { message: "and first name are required." }
  validates :phone, presence: true
end
