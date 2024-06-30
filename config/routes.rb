Rails.application.routes.draw do
  devise_for :admins

  root "home#index"

  namespace :admin do
    resources :orders
    resources :categories

    resources :products do
      resources :stocks
    end
  end

  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end

  resources :categories, only: [:show]
  resources :products, only: [:show]

  get "cart" => "carts#show"
  post "checkout" => "checkouts#create"
  get "/success", to: "checkouts#success"
  get "/cancel", to: "checkouts#cancel"
  post "webhooks" => "webhooks#stripe"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
