class OrderItemsController < ApplicationController

  def create
    order_data = session[:order_data] || {}
    order_data["items"] ||= []

    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    # Find existing order item by product_id
    existing_item = order_data["items"].find { |item| item["product_id"] == product_id }

    if existing_item
      # Update the quantity of the existing item
      existing_item["quantity"] += quantity
    else
      # Add a new order item
      order_data["items"] << { "product_id" => product_id, "quantity" => quantity }
    end

    session[:order_data] = order_data

    @order = Order.new
    @order_items = session_order_items.map do |item|
      product = Product.find_by(id: item[:product_id])
      OrderItem.new(product: product, quantity: item[:quantity])
    end.compact

    # Explicitly associate the order items with the @order instance
    @order.order_items = @order_items

    # Create a temporary order instance for the view's rendering context
    @temp_order = Order.new
    session_order_items.each do |item|
      @temp_order.order_items.build(product_id: item[:product_id], quantity: item[:quantity])
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    if params[:id]
      # Destroying an OrderItem from a finalized order in the database
      order_item = OrderItem.find(params[:id])
      order_item.destroy
    else
      # Destroying an OrderItem from an unsubmitted order in the session
      product_id = params[:product_id].to_i
      session[:order_data]["items"].delete_if { |item| item["product_id"] == product_id }

      # For updating the view after deletion
      @order = Order.new
      @order.order_items = session_order_items.map do |item|
        product = Product.find_by(id: item[:product_id])
        OrderItem.new(product: product, quantity: item[:quantity])
      end.compact
    end

    # Redirect or render appropriate response
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to orders_new_path, notice: 'Item was successfully removed.' }
    end
  end

  private

    def order_item_params
      params.permit(:product_id, :quantity)
    end

    def session_order_items
      (session[:order_data] || { "items" => [] })["items"].map do |item|
        { product_id: item["product_id"], quantity: item["quantity"] }
      end
    end
end
