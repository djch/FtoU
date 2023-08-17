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
    order_items.sum(&:price)
  end

  def total_price
    price + delivery_fee
  end

  scope :by_date, lambda { |date|
      case date
      when 'today'
        where("DATE(created_at) = ?", Date.today)
      when 'yesterday'
        where("DATE(created_at) = ?", Date.yesterday)
      when 'this_week'
        where("created_at >= ?", Date.today.beginning_of_week)
      when 'last_week'
        where("created_at >= ? AND created_at <= ?", Date.today.beginning_of_week - 1.week, Date.today.end_of_week - 1.week)
      when 'this_month'
        where("created_at >= ?", Date.today.beginning_of_month)
      when 'last_month'
        where("created_at >= ? AND created_at <= ?", Date.today.beginning_of_month - 1.month, Date.today.end_of_month - 1.month)
      else
        all
      end
    }
  scope :by_status, -> (status) { where(status: status) if status.present? }
  scope :by_paid, -> (paid) { where(paid: ActiveModel::Type::Boolean.new.cast(paid)) if paid.present? }

  private

    def copy_customer_address
      self.street_address = customer.street_address
      self.town           = customer.town
      self.state          = customer.state
      self.postcode       = customer.postcode
      self.country        = customer.country
    end
end