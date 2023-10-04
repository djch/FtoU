class DeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:edit, :update]

  def index
    set_selected_date
    set_displayed_date
    fetch_orders_for_selected_date
    fetch_deliveries_count
    fetch_pending_orders
  end

  def edit
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      redirect_to deliveries_path(date: @order.delivery_date)
    else
      # Handle the error, maybe render the edit form again with the errors
      render :edit
    end
  end

  private

    def set_selected_date
      @selected_date = params[:date]&.to_date || Date.current
    end

    def set_displayed_date
      @displayed_month = params[:month]&.to_i || @selected_date.month
      @displayed_year = params[:year]&.to_i || @selected_date.year
      @displayed_date = Date.new(@displayed_year, @displayed_month, 1)
    end

    def fetch_orders_for_selected_date
      start_of_selected_date = @selected_date.beginning_of_day
      end_of_selected_date = @selected_date.end_of_day
      @orders = Order.includes(:order_items, :customer)
                     .where(delivery_date: start_of_selected_date..end_of_selected_date)
                     .where.not(status: ['cancelled', 'pending'])
                     .order(:delivery_date)
    end

    def fetch_deliveries_count
      @deliveries_count_by_date = Order.delivery_counts_for_month(@displayed_date)
    end

    def fetch_pending_orders
      @pending_orders = Order.includes(:order_items, :customer)
                             .where(status: 'pending')
                             .order(:created_at)
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:delivery_date, :delivery_fee, :notes, :paid)
    end
end
