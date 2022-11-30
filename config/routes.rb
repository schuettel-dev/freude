Rails.application.routes.draw do
  resource :sign_up, only: %i[new create]
  resource :session, only: %i[new create destroy]

  root to: "dashboard#show"
end
