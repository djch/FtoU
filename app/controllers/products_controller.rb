class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products
  def index
    @products = Product.by_price
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            'messages', partial: 'shared/errors',
            locals: { errors: @product.errors }
          ), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product was successfully updated." # Redirect to the index
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            'messages', partial: 'shared/errors',
            locals: { errors: @product.errors }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :price, :unit, :image, :description, :available)
    end
end
