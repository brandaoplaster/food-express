class HomeController < ActionController::Base
  def index
    @main_categories = Category.take(4)
  end
end
