# app/models/concerns/delivery_addressable.rb
module DeliveryAddressable
  extend ActiveSupport::Concern

  included do
    validates :street_address, presence: true
    validates :town, presence: true
    validates :state, presence: true
    validates :postcode, presence: true
    validates :country, presence: true

    validate :street_address_contains_number

    private

      def street_address_contains_number
        unless street_address =~ /\d/
          # Sometimes Google Places lets you choose made up addresses, as long as the street name exists
          errors.add(:street_address, "does not seem to exist in Google's database. Is it valid?")
        end
      end
  end
end
