class Admin::StocksController < AdminController
  before_action :set_stock, only: %i[ show edit update destroy ]

  def index
    @stocks = Stock.where(product_id: params[:product_id])
  end

  def show
  end

  def new
    @product = Product.find(params[:product_id])
    @stock = Stock.new
  end

  def edit
    @product = Product.find(params[:product_id])
    @stock = Stock.find(params[:id])
  end

  def create
    @product = Product.find(params[:product_id])
    @stock = @product.stocks.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to admin_product_stock_url(@product, @stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to admin_product_stock_url(@stock.product, @stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock.destroy!

    respond_to do |format|
      format.html { redirect_to admin_product_stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_stock
      @stock = Stock.find(params[:id])
    end

    def stock_params
      params.require(:stock).permit(:amount, :size)
    end
end
