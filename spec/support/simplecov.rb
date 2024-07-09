require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Helpers", "app/helpers"
  add_group "Mailers", "app/mailers"
  add_group "Jobs", "app/jobs"
  add_group "Libraries", "lib"
  add_group "Services", "app/services"
  add_group "Views", "app/views"
end
