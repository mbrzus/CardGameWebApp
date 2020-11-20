Rails.application.routes.draw do

  # A user should first be directed to a welcome page that allows them to either login, signup or continue as a guest
  root to: redirect('/login')
  resources :accounts
  match '/login', to: 'sessions#new', via: :get
  match '/login_create', to: 'sessions#create', via: :post
  match '/logout', to: 'sessions#destroy', via: :delete
  match '/signup', to: 'accounts#new', via: :get
  match '/signup_create', to: 'accounts#create', via: :post

  resources :cards
  post 'cards/delete_decks_in_room'
  post 'cards/draw_cards_from_dealer'
  post 'cards/give_cards_transaction'
  post 'cards/give_cards'
  post 'cards/draw_cards'

  # adds in the paths associated with rooms, which are the game sessions
  resources :rooms
  post 'rooms/join_room'
  post 'rooms/create_new_deck'
  post 'rooms/:id/reset', :controller => 'rooms', :action => 'reset'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :players
  post 'players/create'

 # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
