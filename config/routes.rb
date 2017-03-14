Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "application#index"

  get "/home", to: "albums#home"


  post "/albums/search", to: "albums#search"
  get "/albums/search", to: "albums#search"

  # root to: "albums#index"

  post "/answers", to: "albums#answers"

  get "/play", to: "albums#play"

  get "/index", to: "albums#index"

end
