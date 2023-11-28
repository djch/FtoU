class Order < ApplicationRecord
  include DeliveryAddressable

  belongs_to :customer
  has_many :order_items, -> { order(created_at: :asc) }, dependent: :destroy, inverse_of: :order
  has_many :products, through: :order_items

  has_person_name

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  # Validations
  validate :at_least_one_order_item
  validates :status, presence: true, inclusion: { in: %w(pending confirmed cancelled delivered) }
  validates_associated :order_items

  before_create :copy_customer_details
  before_save :confirm_order, if: :will_save_change_to_delivery_date?

  # Scopes
  scope :recently_created, -> { order(created_at: :desc) }
  scope :by_status, -> (status) { where(status: status) if status.present? }
  scope :by_paid, -> (paid) { where(paid: ActiveModel::Type::Boolean.new.cast(paid)) if paid.present? }
  scope :for_delivery_date, ->(date) { where(delivery_date: date.beginning_of_day..date.end_of_day) }
  scope :for_month, ->(date) { where(delivery_date: date.beginning_of_month..date.end_of_month) }

  # Class Methods
  def self.by_date(date)
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
  end

  def self.delivery_counts_for_month(date)
    counts_by_date = {}
    (date.beginning_of_month.to_date..date.end_of_month.to_date).each do |day|
      start_of_day = day.beginning_of_day
      end_of_day = day.end_of_day
      count = where(delivery_date: start_of_day..end_of_day)
                    .where.not(status: ['cancelled', 'pending'])
                    .count
      counts_by_date[day] = count
    end
    counts_by_date
  end

  # Instance Methods
  def price
    if order_items.any?(&:new_record?)
      order_items.sum(&:live_price)
    else
      order_items.sum(&:price)
    end
  end

  def total_price
    price + (delivery_fee || 0)
  end

  def item_summary
    summary = order_items.includes(:product)
                         .group_by { |item| item.product.unit }
                         .map do |unit, items|
                           "#{items.sum(&:quantity)} #{unit.pluralize(items.sum(&:quantity))}"
                         end

    summary.join(" + ")
  end

  private

    def copy_customer_details
      # Contact
      self.first_name     = customer.first_name
      self.last_name      = customer.last_name
      self.company_name   = customer.company_name
      self.phone          = customer.phone
      # Address
      self.street_address = customer.street_address
      self.town           = customer.town
      self.state          = customer.state
      self.postcode       = customer.postcode
      self.country        = customer.country
    end

    def at_least_one_order_item
      if order_items.empty? || order_items.all? { |item| item.marked_for_destruction? }
        errors.add(:base, "You forgot to add any items to your order. Use the 'Add to order' button to select products.")
      end
    end

    def confirm_order
      self.status = 'confirmed' unless delivery_date.nil?
    end
end
