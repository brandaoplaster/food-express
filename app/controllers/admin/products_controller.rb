class Admin::ProductsController < ApplicationController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  def index
    @admin_products = Admin::Product.all
  end

  def show
  end

  def new
    @admin_product = Admin::Product.new
  end

  def edit
  end

  def create
    @admin_product = Admin::Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_product.update(admin_product_params)
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_product
    @admin_product = Admin::Product.find(params[:id])
  end

  def admin_product_params
    params.require(:admin_product).permit(:name, :description, :price, :category_id, :active)
  end
end
