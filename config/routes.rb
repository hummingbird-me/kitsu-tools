require 'sidekiq/web'

Hummingbird::Application.routes.draw do
  devise_for :users

  root :to => "home#index"

  resources :anime do
    resources :quotes do
      member { post :vote }
    end
  end

  # Personalize Filters
  match '/anime/filter/:filter(/:page)' => 'anime#index', :as => :filtered_listing

  resources :genres
  resources :producers

  # Watchlist
  match '/watchlist/add/:anime_id' => 'watchlist#add_to_watchlist', :as => :add_to_watchlist
  match '/watchlist/remove/:anime_id' => 'watchlist#remove_from_watchlist', :as => :remove_from_watchlist
  match '/watchlist/rate/:anime_id/:rating' => 'watchlist#update_rating', :as => :update_rating

  # Admin Panel
  constraint = lambda {|request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
  constraints constraint do
    match '/kotodama' => 'admin#index', :as => :admin_panel
    mount Sidekiq::Web => '/kotodama/sidekiq'
    mount RailsAdmin::Engine => '/kotodata/rails_admin', :as => 'rails_admin'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
