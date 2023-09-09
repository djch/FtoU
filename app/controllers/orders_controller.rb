class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[ new ]
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders
  def index
    @orders = Order.recently_created.where.not(customer: nil)
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
    # Step 1: Handle Order Creation with Associated Order Items
    @order = Order.new(order_params)
    @order.status = 'pending'

    # Fetch order items from the session
    session_order_items.each do |item|
      @order.order_items.build(product_id: item[:product_id], quantity: item[:quantity])
    end

    # Step 2: Match or Create a Customer
    customer = Customer.find_by(email: params[:order][:email]) ||
               Customer.find_by(phone: params[:order][:phone])

    if customer.nil?
      customer = Customer.create(customer_params)
    end

    # Step 3: Associate the Order with the Customer
    @order.customer = customer

    # Step 4: Update the Customer's Address
    customer.update(address_params)

    if @order.save
      session.delete(:order_data)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'order_form', partial: 'orders/confirmation', locals: { order: @order }
          )
        end
        format.html { redirect_to some_path, notice: 'Order was successfully created.' }
      end
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

  def confirmation_preview
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    render 'orders/confirmation_preview', layout: 'application'
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:paid, :status, :delivery_date, :notes, :delivery_fee, :product_ids => [])
    end

    def session_order_items
      (session[:order_data] || { "items" => [] })["items"].map do |item|
        { product_id: item["product_id"], quantity: item["quantity"] }
      end
    end

    def customer_params
      params.require(:order).permit(:name, :email, :phone)
    end

    def address_params
      params.require(:order).permit(:street_address, :town, :state, :postcode, :country)
    end
end
