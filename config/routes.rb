Rails.application.routes.draw do
  root 'welcome#index'

  get 'welcome/index'

  get 'mail/new'

  resources :states

  get "missions/inbox", to: "missions#show"
  post "missions/inbox", to: "missions#capture"
  post "missions/:id", to: "missions#capture"
  resources :missions

  resources :resources

  get "clams/:id/snippet", to: "clams#show_snippet"
  resources :clams

  devise_for :users, controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               registrations: 'users/registrations',
               confirmations: 'users/confirmations',
               passwords: 'users/passwords',
               sessions: 'users/sessions',
               unlocks: 'users/unlocks',
               invitations: 'users/invitations'
             }

  get "calendars/import"
  post "calendars/import"
  post "calendars/create_caldav"
  resources :calendars
  resources :recurrences
  
  get "gate/index"
  get "gate/login"
  get "gate/logout"
  post "gate/login"

  match "events/create_recurrence", :via => :post
  post "events/new"
  get "events/fetch"
  resources :events
 
  get "inbox/missions"
  get "inbox/recurrences"

  post "recurrences/add_events"
  post "events/ajax_create_event_from_old_event"

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
