module Admin
  class DashboardMetricsServices
    attr_reader :records

    def initialize
      @records = []
    end

    def call
      @records[:orders] = fulfilled_orders
      @records[:sales] = quantity_ordered_per_day
      @records[:revenue] = total_sales_today
      @records[:avg_sale] = average_order_value_today
      @records[:per_sale] = average_product_quantity_per_order_today
      @records[:orders_by_day] = orders_grouped_by_day_last_week
      revenue_by_day = calculate_revenue_by_day(@records[:orders_by_day])
      @records[:revenue_by_day] = complete_and_order_revenue_by_day(revenue_by_day)
    end

    private

    def fulfilled_orders
      Order.where(fulfilled: false).order(created_at: :desc).take(5)
    end

    def quantity_ordered_per_day
      Order.where(created_at: Time.now.midnight..Time.now).count
    end

    def total_sales_today
      Order.where(created: Time.now.midnight..Time.now).sum(:total).round()
    end

    def average_order_value_today
      Order.where(created: Time.now.midnight..Time.now).average(:total).round()
    end

    def average_product_quantity_per_order_today
      OrderProduct.joins(:order).where(orders: { created_at: Time.now.midnight..Time.now }).average(:quantity)
    end

    def orders_grouped_by_day_last_week
      orders_by_day = Order.where("created_at > ?", Time.now - 7.days).order(:created_at)
      orders_by_day.group_by { |order| order.created_at.to_date }
    end

    def calculate_revenue_by_day(orders_by_day)
      orders_by_day.map { |day, orders| [day.strftime("%A"), orders.sum(&:total)] }
    end

    def complete_and_order_revenue_by_day(revenue_by_day)
      if revenue_by_day.count < 7
        days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        data_hash = revenue_by_day.to_h
        current_day = Date.today.strftime("%A")
        current_day_index = days_of_week.index(current_day)
        next_day_index = (current_day_index + 1) % days_of_week.length

        ordered_days_with_current_last = days_of_week[next_day_index..-1] + days_of_week[0..next_day_index]
        complete_ordered_array_with_current_last = ordered_days_with_current_last.map { |day| [day, data_hash.fetch(day, 0)] }
        return complete_ordered_array_with_current_last
      end
      revenue_by_day
    end
  end
end
