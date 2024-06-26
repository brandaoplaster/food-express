class ProducsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end
end
