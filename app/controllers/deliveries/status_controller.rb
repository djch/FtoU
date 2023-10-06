module Deliveries

  class StatusController < ApplicationController
    before_action :authenticate_user!
    before_action :set_delivery

    def update
      if @delivery.update(delivery_params)
        render partial: 'deliveries/delivery', locals: { delivery: @delivery }
      else
        # How can toggling attributes via click possibly fail?
      end
    end

    private

      def set_delivery
        @delivery = Order.find(params[:id])
      end

      def delivery_params
        params.require(:order).permit(:status, :paid)
      end
  end
end
