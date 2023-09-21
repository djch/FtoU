class Customer < ApplicationRecord
  include Addressable
  include MailchimpSyncable
  include PgSearch::Model

  pg_search_scope :search_by_name, against: [:first_name, :last_name], using: { tsearch: { prefix: true } }
  has_person_name

  has_many :orders

  PHONE_REGEX = /\A(\+?\d{1,4}?[-.\s]?)?(\()?(\d{1,3}?)(?(2)\))[-.\s]?(\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,4}?)\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, presence: { message: "and last name are required." }
  validates :last_name, presence: { message: "and first name are required." }
  validates :phone, format: { with: PHONE_REGEX, message: "is not a valid phone number" }
  validates :email, format: { with: EMAIL_REGEX, message: "is not a valid email address" }
end
