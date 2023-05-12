Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resource :sign_up, only: %i[new create]
  resource :profile, only: %i[show edit update]

  resources :games, only: %i[index show new create edit update destroy] do
    get "join/:token", action: :join, as: :join
    delete "leave", action: :leave, as: :leave

    collection do
      resource :catalogue, only: %i[show], module: :games, as: :game_catalogue
    end

    resource :phases, only: [:show, :update], module: :games
    resource :final_ranking, only: :show, module: :games

    resource :beatle, only: [], module: :games do
      resources :playlists, module: :beatle, only: [:show, :edit, :update]
      resources :playlist_guesses, module: :beatle, only: [:edit, :update]
    end
  end

  root to: "games#index"
end
