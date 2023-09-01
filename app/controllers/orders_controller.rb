class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[ new ]
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders
  def index
    @orders = Order.all
    @orders = Order.all.by_status(params[:status]).by_paid(params[:paid]).by_date(params[:date])
    @orders = @orders.by_paid(params[:paid]) if params[:paid].present?
    @orders = @orders.by_date(params[:date]) if params[:date].present?

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /orders/1
  def show
    @order_items = @order.order_items
  end

  # GET /orders/new
  def new
    @order = Order.new
    @products = Product.where(available: true)
    @current_step = params[:step] || 1
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @current_step = params[:step] || 1

    if @current_step < 3
      @current_step += 1
      render turbo_stream: turbo_stream.replace('order-step', partial: "step#{@current_step}")
    elsif @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      respond_to do |format|
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            'messages', partial: 'shared/errors',
            locals: { errors: @order.errors }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:paid, :status, :delivery_date, :notes, :delivery_fee, :product_ids => [])
    end
end
