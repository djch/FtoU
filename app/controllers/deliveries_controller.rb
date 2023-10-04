class DeliveriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @selected_date = params[:date]&.to_date || Date.today

    # Determine the displayed month and year
    @year = params[:year]&.to_i || @selected_date.year
    @month = params[:month]&.to_i || @selected_date.month
    @date = Date.new(@year, @month, 1)


    if params[:date]
      # Query the Order model based on the delivery_date field
      @orders = Order.includes(:order_items, :customer).where(delivery_date: @selected_date)
    else
      # Default to showing today's orders if no date parameter is provided
      @orders = Order.includes(:order_items, :customer).where(delivery_date: Date.today)
    end
  end
end
