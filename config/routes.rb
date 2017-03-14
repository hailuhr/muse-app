Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "application#index"

  get "/home", to: "artists#home"


  post "/artists/search", to: "artists#search"
  get "/artists/search", to: "artists#search"

  # root to: "artists#index"

  post "/answers", to: "artists#answers"

  get "/play", to: "artists#play"

  get "/index", to: "artists#index"

end
