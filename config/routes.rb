require 'sidekiq/web'

Hummingbird::Application.routes.draw do
  # API v2
  namespace :api do
    namespace :v2 do
      resources :anime
      resources :quotes
      resources :franchises
    end
  end

  match '/sign-in' => 'auth#sign_in_action'

  use_doorkeeper
  match '/oauth/me' => 'oauth#me'

  devise_for :users, controllers: { 
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :notifications

  mount Forem::Engine => "/community"

  match '/lists' => 'home#lists'
  match '/privacy' => 'home#privacy'
  match '/developers/api' => 'home#api'

  # Recommendations
  match '/recommendations' => 'recommendations#index'
  match '/recommendations/not_interested' => 'recommendations#not_interested'
  match '/recommendations/plan_to_watch' => 'recommendations#plan_to_watch'
  match '/recommendations/force_update' => 'recommendations#force_update'

  # Chat
  match '/chat' => 'chat#index'
  #match '/chat/ping' => 'chat#ping'
  #match '/chat/messages' => 'chat#messages'
  #match '/chat/new_message' => 'chat#new_message'

  match '/unsubscribe/newsletter/:code' => 'home#unsubscribe'
  match "/beta_invites/resend_invite" => "beta_invites#resend_invite", as: :resend_beta_invite
  match "/beta_invites/invite_code" => "beta_invites#invite_code"
  match "/beta_invites/unsubscribe" => "beta_invites#unsubscribe"
  resources :beta_invites

  root :to => "home#index"

  # Dashboard
  match '/dashboard' => 'home#dashboard'
  match '/feed' => "home#feed"

  resources :users do
    get :watchlist
    get :reviews
    get :forum_posts
    get :feed
    get :followers
    get :following
    get :favorite_anime
    get :trigger_forum_sync
    get :cover_image

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
  match '/search' => 'search#basic', as: :search
  
  # Imports
  match '/mal_import' => 'imports#new', via: [:post]

  # Random anime
  match '/random/anime' => 'anime#random'
  match '/anime/upcoming(/:season)' => 'anime#upcoming', as: :anime_season
  match '/anime/filter(/:sort)' => 'anime#filter', as: :anime_filter

  resources :anime do
    post :get_episodes_from_thetvdb
    post :get_metadata_from_mal
    post :toggle_favorite

    resources :casts
    resources :quotes do
      member { post :vote }
    end
    resources :reviews do
      member { post :vote }
    end
    resources :episodes do
      member {
        post :watch
        post :bulk_update
      }
    end
  end

  match '/reviews' => 'reviews#full_index'

  resources :genres do
    post :add_to_favorites
    post :remove_from_favorites
  end

  resources :producers
  resources :characters

  # Watchlist
  resources :watchlists
  match '/watchlist/remove' => 'watchlists#remove_from_watchlist', 
    as: :remove_from_watchlist
  match '/watchlist/rate/:anime_id/:rating' => 'watchlists#update_rating', 
    as: :update_rating
  match '/watchlist/update' => 'watchlists#update_watchlist'

  match '/u/:username' => 'users#redirect_short_url'


  match '/unsubscribe/:unsub_type/:hash' => 'users#unsubscribe'

  # Admin Panel
  constraint = lambda do |request|
    request.env["warden"].authenticate? and request.env['warden'].user.admin?
  end
  constraints constraint do
    match '/kotodama' => 'admin#index', as: :admin_panel
    match '/kotodama/login_as' => 'admin#login_as_user'
    match '/kotodama/find_or_create_by_mal' => 'admin#find_or_create_by_mal'
    match '/kotodama/invite_to_beta' => 'admin#invite_to_beta'
    post '/kotodama/toggle_forum_kill_switch' => 'admin#toggle_forum_kill_switch'
    post '/kotodama/toggle_registration_kill_switch' => 'admin#toggle_registration_kill_switch'

    mount Sidekiq::Web => '/kotodama/sidekiq'
    mount RailsAdmin::Engine => '/kotodama/rails_admin', as: 'rails_admin'
    mount Split::Dashboard => '/kotodama/split'
    mount BeanstalkdView::Server, at: '/kotodama/beanstalkd'
  end

  mount API => '/'
end
