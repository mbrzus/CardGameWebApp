Rails.application.routes.draw do
  resources :players
  post 'players/create'

end
