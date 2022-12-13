Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resource :sign_up, only: %i[new create]
  resources :games, only: %i[index show edit update destroy]

  resources :game_templates, only: %i[index] do
    resource :instance, only: %i[new create], module: :game_templates
  end

  root to: "games#index"
end
