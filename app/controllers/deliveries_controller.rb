class DeliveriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where.not(delivery_date: nil).order(:delivery_date)
  end
end
