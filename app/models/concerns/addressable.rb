module Addressable
  extend ActiveSupport::Concern

  included do
    validates :street_address, presence: true
    validates :town, presence: true
    validates :state, presence: true
    validates :postcode, presence: true
    validates :country, presence: true
  end
end
