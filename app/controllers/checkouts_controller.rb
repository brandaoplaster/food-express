class CheckoutsController < ApplicationController
  def create
    cart = params[:cart]
    session = Admin::CheckoutServices.new(cart).call
    render json: { url: session.url }
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def success
    render :success
  end

  def cancel
    render :cancel
  end
end
