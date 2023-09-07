# app/controllers/order_items_controller.rb
class OrderItemsController < ApplicationController
  def create
    Rails.logger.info "Order Data in Session: #{session[:order_data].inspect}"

    order_data = session[:order_data] || {}
    order_data["items"] ||= []

    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    order_data["items"] << { product_id: product_id.to_i, quantity: quantity }

    session[:order_data] = order_data

    @order = Order.new
    @order_items = order_data["items"].map do |item|
      product = Product.find_by(id: item[:product_id])
      if product.nil?
        Rails.logger.error "Couldn't find Product with ID: #{item[:product_id]}"
        next
      end
      OrderItem.new(product: product, quantity: item[:quantity])
    end.compact

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def order_item_params
      params.permit(:product_id, :quantity)
    end
end
