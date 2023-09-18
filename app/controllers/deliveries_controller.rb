class DeliveriesController < ApplicationController
  def index
    @orders = Order.where.not(delivery_date: nil).order(:delivery_date)
  end
end
