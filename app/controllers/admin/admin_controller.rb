  class Admin::AdminController < ApplicationController
    layout "admin"
    before_action :authenticate_admin!

    def index
      @service = Admin::DashboardMetricsServices.new
      @service.call
    end
  end
