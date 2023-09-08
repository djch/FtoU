class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[ new ]
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders
  def index
    @orders = Order.where.not(customer: nil)
    @orders = @orders.by_status(params[:status]).by_paid(params[:paid]).by_date(params[:date])
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
    session_order_items.each do |item|
      @order.order_items.build(product_id: item[:product_id], quantity: item[:quantity])
    end

    @products = Product.all

    # Initialize session data if not already present
    session[:order_data] ||= { "items" => [] }

    order_items_data = session[:order_data]["items"]

    @order_items = order_items_data.map do |item|
      product = Product.find_by(id: item["product_id"])
      if product
        OrderItem.new(product: product, quantity: item["quantity"])
      else
        nil
      end
    end.compact
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.status = 'pending'

    if @order.save
      session.delete(:order_data)
      redirect_to order_confirmation_path(@order), notice: 'Order was successfully created.'
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

    def session_order_items
      (session[:order_data] || { "items" => [] })["items"].map do |item|
        { product_id: item["product_id"], quantity: item["quantity"] }
      end
    end
end
