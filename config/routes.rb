Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      # Auth
      post "/login", to: "auth#login"
      post "/register", to: "auth#register"

      # Login
      get "/posts/:id", to: "posts#show"
      get "/posts", to: "posts#index"
      post "/posts", to: "posts#create"
      delete "/posts/:id", to: "posts#destroy"

      # Like
      post "/posts/:id/like", to: "likes#create"
      delete "/posts/:id/like", to: "likes#destroy"
    end
  end
end
