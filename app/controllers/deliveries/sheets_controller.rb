module Deliveries

  class SheetsController < ApplicationController
    before_action :authenticate_user!

    # GET /delivery/sheets
    def index
      if params[:start_date] && params[:end_date]
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @orders = Order.where(status: 'confirmed').where(delivery_date: start_date..end_date).order(:delivery_date)
      elsif params[:date]
        date = Date.parse(params[:date])
        @orders = Order.where(status: 'confirmed').where(delivery_date: date).order(:delivery_date)
      else
        # Default to today's date when no parameters are provided and redirect
        today = Date.current
        redirect_to delivery_sheets_path(date: today)
      end
    end

    # GET /delivery/sheets/1
    def show
      @order = Order.find(params[:id])
    end
  end

end
