require 'sidekiq/web'

Hummingbird::Application.routes.draw do
  resources :library_entries, except: [:new, :edit]
  resources :manga_library_entries, except: [:new, :edit]
  resources :franchises, only: [:index, :show]
  resources :full_anime, only: [:show, :update, :destroy]
  resources :full_manga, only: [:show]
  resources :news_feeds, only: [:index]
  resources :quotes

  resources :stories do
    get :likers
  end

  resources :substories, only: [:index, :create, :destroy]
  resources :user_infos, only: [:show]
  resources :changelogs, only: [:index]

  resources :reviews do
    post :vote
  end

  get '/popular' => 'home#static'
  get '/radio' => 'home#static'

  get '/apps/mine' => 'apps#mine'
  resources :apps

  resource :chat, only: [:show, :create, :destroy] do
    post :ping
  end

  get '/sign-in' => 'home#static'
  get '/sign-up' => 'home#static'

  post '/sign-in' => 'auth#sign_in_action'
  post '/sign-up' => 'auth#sign_up_action'
  post '/sign-out' => 'auth#sign_out_action'

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :notifications, only: [:index, :show]

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

  get '/privacy' => 'home#static'
  get '/branding' => 'home#static'

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

  get '/onboarding(/:id)' => 'home#static'

  get '/users/:id/watchlist' => redirect {|params, request| "/users/#{params[:id]}/library" }
  get '/u/:id' => redirect {|params, request| "/users/#{params[:id]}" }
  get '/users/:id/feed' => redirect {|params, request| "/users/#{params[:id]}" }
  get '/users/to_follow' => 'users#to_follow' # public endpoint for users to follow

  resources :users, only: [:index, :show, :update] do
    get 'library/manga' => 'users#manga_library'
    get :library
    get :reviews
    get :followers
    get :following
    get :favorite_anime

    resources :lists

    put "/cover_image"  => 'users#update_cover_image',  as: :cover_image
    put "/avatar"       => 'users#update_avatar',       as: :avatar

    post :follow
    post :comment
    post :update_setting

    post "/disconnect/facebook" => 'users#disconnect_facebook',
      as: :disconnect_facebook
  end

  # Settings
  get '/settings' => 'settings#index'
  namespace :settings do
    post :resend_confirmation

    # Legacy routes
    get 'backup/:action', to: 'backup'
    # New routes
    # Download
    get 'backup/download' => 'backup#download'
    # Dropbox
    get 'backup/dropbox' => 'backup#dropbox_connect'
    post 'backup/dropbox' => 'backup#dropbox'
    delete 'backup/dropbox' => 'backup#dropbox_disconnect'

    # Imports
    post 'import/myanimelist' => 'import#myanimelist'
  end

  # Search
  get '/search' => 'search#basic', as: :search

  # Imports
  post '/mal_import', to: redirect('/settings/import/myanimelist')

  # Random anime
  get '/random/anime' => 'anime#random'
  get '/anime/upcoming(/:season)' => 'anime#upcoming', as: :anime_season
  get '/anime/filter(/:sort)' => 'anime#filter', as: :anime_filter

  resources :castings, only: [:index]

  resources :anime, only: [:show, :index, :update] do
    resources :quotes
    resources :reviews
    resources :episodes
  end

  resources :manga, only: [:index, :show]

  resources :genres, only: [:index, :show] do
    post :add_to_favorites
    post :remove_from_favorites
  end

  resources :producers
  resources :characters, only: [:show]

  # Versions
  resources :versions, except: [:new, :create, :show]
  get '/edits' => 'versions#index'

  # Admin Panel
  authenticated :user, lambda {|u| u.admin? } do
    get '/kotodama' => 'admin#index', as: :admin_panel
    get '/kotodama/stats' => 'admin#stats'
    get '/kotodama/login_as' => 'admin#login_as_user'
    get '/kotodama/find_or_create_by_mal' => 'admin#find_or_create_by_mal'
    get '/kotodama/users_to_follow' => 'admin#users_to_follow'
    get '/kotodama/users_to_follow_submit' => 'admin#users_to_follow_submit'
    get '/kotodama/blotter_set' => 'admin#blotter_set'
    get '/kotodama/blotter_clear' => 'admin#blotter_clear'
    post '/kotodama/deploy' => 'admin#deploy'
    post '/kotodama/publish_update' => 'admin#publish_update'

    mount Sidekiq::Web => '/kotodama/sidekiq'
    mount RailsAdmin::Engine => '/kotodama/rails_admin', as: 'rails_admin'
    mount PgHero::Engine => '/kotodama/pghero'
    mount Kibana::Rack::Web => '/kibana'
  end

  mount API => '/'
end
