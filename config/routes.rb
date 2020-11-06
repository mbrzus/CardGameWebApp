Rails.application.routes.draw do
  resources :players
  post 'players/create'
  root :to => redirect('/players')
end
