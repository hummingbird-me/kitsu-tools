require 'sidekiq/web'

Hummingbird::Application.routes.draw do
  resources :library_entries
  resources :franchises
  resources :full_anime
  resources :news_feeds
  resources :quotes
  resources :stories
  resources :user_infos
  resources :changelogs
  resources :reviews do
    post :vote
  end

  get '/sign-in' => 'auth#sign_in_action'
  post '/sign-out' => 'auth#sign_out_action'

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :notifications

  namespace :community do
    get '/' => 'forums#index'
    resources :forums do
      resources :topics
    end
  end

  namespace :api do
    namespace :v2 do
      resources :anime
    end
  end

  get '/privacy' => 'home#privacy'

  # Recommendations
  get '/recommendations' => 'recommendations#index'
  post '/recommendations/not_interested' => 'recommendations#not_interested'
  post '/recommendations/plan_to_watch' => 'recommendations#plan_to_watch'
  get '/recommendations/force_update' => 'recommendations#force_update'

  get '/unsubscribe/newsletter/:code' => 'home#unsubscribe'

  root :to => "home#index"

  # Dashboard
  get '/dashboard' => 'home#dashboard'
  get '/feed' => 'home#feed'

  get '/users/:id/watchlist' => redirect {|params, request| "/users/#{params[:id]}/library" }
  get '/u/:id' => redirect {|params, request| "/users/#{params[:id]}" }
  get '/users/:id/feed' => redirect {|params, request| "/users/#{params[:id]}" }

  resources :users do
    get :library
    get :reviews
    get :followers
    get :following
    get :favorite_anime
    get :trigger_forum_sync

    resources :lists

    put "/cover_image"  => 'users#update_cover_image',  as: :cover_image
    put "/avatar"       => 'users#update_avatar',       as: :avatar

    post :follow
    post :comment
    post :toggle_connection
    post :update_setting

    post "/disconnect/facebook" => 'users#disconnect_facebook',
      as: :disconnect_facebook
  end

  # Search
  get '/search' => 'search#basic', as: :search

  # Imports
  post '/mal_import' => 'imports#new'

  # Random anime
  get '/random/anime' => 'anime#random'
  get '/anime/upcoming(/:season)' => 'anime#upcoming', as: :anime_season
  get '/anime/filter(/:sort)' => 'anime#filter', as: :anime_filter

  resources :anime do
    resources :casts
    resources :quotes do
      member { post :vote }
    end
    resources :reviews
  end

  resources :manga

  resources :genres do
    post :add_to_favorites
    post :remove_from_favorites
  end

  resources :producers
  resources :characters

  # Watchlist
  #resources :watchlists
  #match '/watchlist/remove' => 'watchlists#remove_from_watchlist',
  #  as: :remove_from_watchlist
  #match '/watchlist/rate/:anime_id/:rating' => 'watchlists#update_rating',
  #  as: :update_rating
  #match '/watchlist/update' => 'watchlists#update_watchlist'

  # Admin Panel
  authenticated :user, lambda {|u| u.admin? } do
    get '/kotodama' => 'admin#index', as: :admin_panel
    get '/kotodama/stats' => 'admin#stats'
    get '/kotodama/login_as' => 'admin#login_as_user'
    get '/kotodama/find_or_create_by_mal' => 'admin#find_or_create_by_mal'
    get '/kotodama/users_to_follow' => 'admin#users_to_follow'
    get '/kotodama/users_to_follow_submit' => 'admin#users_to_follow_submit'

    mount Sidekiq::Web => '/kotodama/sidekiq'
    mount RailsAdmin::Engine => '/kotodama/rails_admin', as: 'rails_admin'
    mount Split::Dashboard => '/kotodama/split'
  end

  mount API => '/'
end
