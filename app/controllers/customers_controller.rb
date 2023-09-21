class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_customer, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @customers = Customer.search_by_name(params[:query])
    else
      @customers = Customer.order(updated_at: :desc)
    end
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('messages', partial: 'shared/errors', locals: { errors: @customer.errors }), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # GET /customers/1
  def show
  end

  def edit
  end

  # PATCH/PUT /orders/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer updated'
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @customer.destroy
    redirect_to customers_path, notice: 'Customer deleted'
  end

  private

    def find_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(
        :name, :company_name, :phone, :email, :street_address, :town, :state, :postcode, :country, :delivery_notes
      )
    end
end
