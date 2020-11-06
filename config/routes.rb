Rails.application.routes.draw do

  resources :cards
  # map '/' to be a redirect to '/add_name'
  post 'cards/create_new_deck'
  post 'cards/delete_decks_in_room'
  root :to => redirect('/cards')
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :players
  post 'players/create'
  root :to => redirect('/players')
end
