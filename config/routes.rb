Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :items do
        member { post :like }
      end
      get "my/items", to: "items#my_items"

      get "me", to: "auth#me"
      post "auth/refresh", to: "auth#refresh"
      delete "logout", to: "auth#logout"
    end
  end

  get "/auth/google", to: "oauth#google", as: :google_oauth_start
  match "/auth/:provider/callback", to: "oauth#google_callback", via: %i[get post]
  match "/auth/failure", to: "oauth#failure", via: %i[get post]
end
