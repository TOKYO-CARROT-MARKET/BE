Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :items

      post "signup", to: "auth#signup"
      post "login", to: "auth#login"
      delete "logout", to: "auth#logout"
      get "me", to: "auth#me"
    end
  end
end
