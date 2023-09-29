class DeliveriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @year = params[:year]&.to_i || Time.now.year
    @month = params[:month]&.to_i || Time.now.month
    @date = Date.new(@year, @month, 1)
    @selected_date = params[:date]&.to_date || Date.today

    if params[:date]
      # Query the Order model based on the delivery_date field
      @orders = Order.includes(:order_items, :customer).where(delivery_date: @selected_date)
    else
      # Default to showing today's orders if no date parameter is provided
      @orders = Order.includes(:order_items, :customer).where(delivery_date: Date.today)
    end
  end
end
