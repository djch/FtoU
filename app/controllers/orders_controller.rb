class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[ new create ]
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_offered_products, only: %i[ show new edit create destroy ]

  # GET /orders
  def index
    @orders = Order.includes(:customer, :order_items)
                   .recently_created
                   .where.not(customer: nil)
                   .by_status(params[:status])
                   .by_paid(params[:paid])
                   .by_date(params[:date])

    set_page_and_extract_portion_from @orders

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /orders/1
  def show
    session.delete(:order_data)
    @order_items = @order.order_items
    @products = Product.where(available: true)
    Rails.logger.debug "Order persisted state: #{@order.persisted?}"
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.build_customer  # init customer fields
    session_order_items.each do |item|
      @order.order_items.build(product_id: item[:product_id], quantity: item[:quantity])
    end

    @products = Product.where(available: true)

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

    current_page = OpenStruct.new(
      seo_title: "Order Form", description: "Place a delivery order from Firewood To U"
    )
    render layout: "layouts/default/application"
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    # Step 1: Handle Order Creation with Associated Order Items
    @order = Order.new(order_params.except(:customer_attributes))
    @order.status = 'pending'

    # Fetch order items from the session
    session_order_items.each do |item|
      @order.order_items.build(product_id: item[:product_id], quantity: item[:quantity])
    end

    # Step 2: Match or Create a Customer
    email = order_params[:customer_attributes][:email]
    phone = order_params[:customer_attributes][:phone]

    customer = Customer.find_by(email: email) || Customer.find_by(phone: phone)
    customer ||= Customer.new(email: email)

    customer_data = order_params.slice(:street_address, :town, :state, :postcode, :country).merge(order_params[:customer_attributes])

    if customer.new_record?
      customer.assign_attributes(customer_data)
      unless customer.save
        @order.errors.add(:customer, :invalid, message: "Customer details are invalid.")
        render :new and return
      end
    else
      customer.update(customer_data)
    end

    # Step 3: Associate the Order with the Customer
    @order.customer = customer

    if @order.save
      @order_items = @order.order_items.reload
      session.delete(:order_data)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_url, notice: 'Order was successfully created.' }
        OrderMailer.notification_for_staff(@order).deliver_now
        OrderMailer.confirmation_for_customer(@order).deliver_now
      end

    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('messages', partial: 'shared/errors', locals: { errors: @order.errors }), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
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

    def set_offered_products
      @products = Product.where(available: true)
    end

    def session_order_items
      (session[:order_data] || { "items" => [] })["items"].map do |item|
        { product_id: item["product_id"], quantity: item["quantity"] }
      end
    end

    def order_params
      params.require(:order).permit(
        :paid, :status, :delivery_date, :notes, :delivery_fee,
        :name, :company_name, :phone,
        :street_address, :town, :state, :postcode, :country,
        :product_ids => [],
        customer_attributes: customer_attributes
      )
    end

    def customer_attributes
      [:id, :name, :email, :phone, :company_name, :delivery_notes, :street_address, :town, :state, :postcode, :country]
    end

end
