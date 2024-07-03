module Admin
  class CheckoutServices
    def initialize(cart)
      @cart = cart
      Stripe.api_key = Rails.configuration.stripe[:secret_key]
    end

    def call
      items = cart.map do |item|
        product = Product.find(item['id'])
        product_stock = product.stocks.find { |ps| ps.size == item['size'] }

        return false if product_stock.amount < item['quantity'].to_i

        build_item(item)
      end
      create_session(items)
    rescue StandardError => e
      return false
    end

    private

    def create_session(items)
      Stripe::Checkout::Session.create(
        mode: 'payment',
        items:,
        success_url: 'http://localhost:3000/success',
        cancel_url: 'http://localhost:3000/cancel'
      )
    end

    def build_item(item)
      {
        quantity: item['quantity'].to_i,
        price_data: {
          product_data: {
            name: item['name'].force_encoding('UTF-8'),
            metadata: {
              product_id: product.id,
              size: item['size'].force_encoding('UTF-8'),
              product_stock_id: product_stock.id
            }
          },
          currency: 'BRL',
          unit_amount: item['price'].to_i * 100
        }
      }
    end
  end
end
