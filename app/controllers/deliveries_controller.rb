class DeliveriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @selected_date = params[:date]&.to_date || Date.current

    # Determine the displayed month and year
    @year = params[:year]&.to_i || @selected_date.year
    @month = params[:month]&.to_i || @selected_date.month
    @date = Date.new(@year, @month, 1)

    start_time = @selected_date.beginning_of_day
    end_time = @selected_date.end_of_day

    if params[:date]
      # Query the Order model based on the delivery_date field
      @orders = Order.includes(:order_items, :customer)
                     .where(delivery_date: start_time..end_time)
                     .where.not(status: ['cancelled', 'pending'])
                     .order(:delivery_date)
    else
      # Default to showing today's orders if no date parameter is provided
      @orders = Order.includes(:order_items, :customer)
                     .where(delivery_date: Date.current.beginning_of_day..Date.current.end_of_day)
                     .where.not(status: ['cancelled', 'pending'])
                     .order(:delivery_date)
    end
  end

end
