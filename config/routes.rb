Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resource :sign_up, only: %i[new create]
  resources :games, only: %i[index show edit update destroy] do
    get "join/:token", action: :join, as: :join
    resource :phases, only: [:show, :update], module: :games

    resource :beatle, only: [], module: :games do
      resources :playlists, module: :beatle, only: [:show, :edit, :update]
      resources :playlist_guesses, module: :beatle, only: [:edit, :update]
    end
  end

  resources :game_templates, only: %i[index] do
    resource :instance, only: %i[new create], module: :game_templates
  end

  resource :profile, only: %i[show edit update]

  root to: "games#index"
end
