module Deliveries
  class SheetsController < ApplicationController

    def index
      if params[:start_date] && params[:end_date]
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @orders = Order.where(status: 'confirmed').where(delivery_date: start_date..end_date).order(:delivery_date)
      elsif params[:date]
        date = Date.parse(params[:date])
        @orders = Order.where(status: 'confirmed').where(delivery_date: date).order(:delivery_date)
      else
        @orders = []  # or however you want to handle this case
      end
    end

    def show
      if params[:id]
        @order = [Order.find(params[:id])]
      else
        redirect_to deliveries_sheets_path, alert: "Invalid parameters."
        return
      end
    end

  end
end
