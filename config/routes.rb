Rails.application.routes.draw do
  # authentication
  resource :session, only: %i[new create destroy]
  resource :sign_up, only: %i[new create]

  # games
  resources :games, only: %i[index] do
    resources :instances, only: %i[new create], module: :games
  end

  # my
  namespace :my do
    resources :games, only: %i[index show edit update destroy]
  end

  root to: "my/games#index"
end
