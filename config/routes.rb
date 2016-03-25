require 'sidekiq/web'

Hummingbird::Application.routes.draw do
  resources :library_entries, except: [:new, :edit]
  resources :manga_library_entries, except: [:new, :edit]
  resources :franchises, only: [:index, :show]
  resources :full_anime, only: [:show, :update, :destroy]
  resources :full_manga, only: [:show, :update]
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

  get '/apps/mine' => 'apps#mine'
  resources :apps

  resource :chat, only: [:show, :create, :destroy] do
    post :ping
  end

  devise_for :users, skip: [:sessions, :registrations], controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # sessions
  get '/sign-in' => 'home#static', as: :new_user_session
  post '/sign-in' => 'auth#sign_in_action', as: :user_session
  match '/sign-out' => 'auth#sign_out_action', as: :destroy_user_session,
    via: [:post, :delete]

  # registrations
  get '/sign-up' => 'home#static', as: :new_user_registration
  post '/sign-up' => 'auth#sign_up_action', as: :user_registration
  get '/users/edit', to: redirect('/settings'), as: :edit_user_registration

  # redirects if there happens to be any outdated links around the web
  get '/users/sign_in', to: redirect('/sign-in')
  get '/users/sign_up', to: redirect('/sign-up')

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

  get '/onboarding(/:id)' => 'home#static'

  get '/pro' => 'home#static'
  resources :pro_membership_plans, only: [:index]
  resources :pro_memberships, only: [:create, :destroy]
  resources :partner_deals, only: [:index, :update]

  get '/u/:id' => redirect {|params| "/users/#{params[:id]}" }
  get '/a/:id' => redirect {|params| "/anime/#{params[:id]}" }
  get '/m/:id' => redirect {|params| "/manga/#{params[:id]}" }
  get '/g/:id' => redirect {|params| "/groups/#{params[:id]}" }

  get '/users/to_follow' => 'users#to_follow' # public endpoint for users to follow

  resources :users, only: [:index, :show, :update] do
    get 'library/manga' => 'users#ember'
    get 'library' => 'users#ember'
    get 'groups' => 'users#ember'
    get 'reviews' => 'users#ember'
    get 'followers' => 'users#ember'
    get 'following' => 'users#ember'

    get 'feed' => redirect {|params| "/users/#{params[:id]}" }
    get 'watchlist' => redirect {|params| "/users/#{params[:id]}/library" }

    resources :lists

    put "/avatar" => 'users#update_avatar', as: :avatar

    post :follow
    post :comment

    post "/disconnect/facebook" => 'users#disconnect_facebook',
      as: :disconnect_facebook
  end

  # Favorite media
  resources :favorites
  post '/favorites/update_all' => 'favorites#update_all'

  resources :groups do
    get 'members' => 'groups#show', on: :member
  end

  resources :group_members

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
  get '/search' => 'search#search'

  # Imports
  post '/mal_import', to: redirect('/settings/import/myanimelist')

  # I'm just gonna awkwardly cram SSO in here because holy fuck our routes.rb is
  # 200LOC, this is absurd.  I'm glad this is all disappearing in V3.
  get '/discourse/sso' => 'users#discourse_sso'

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

  resources :characters, only: [:show]

  # Versions
  resources :versions, except: [:new, :create, :show]
  get '/edits' => 'versions#index'

  # Admin Panel
  constraints(lambda do |req|
    user = Auth::CurrentUserProvider.new(req.env).current_user
    user && user.admin?
  end) do
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
    post '/kotodama/reset_break_counter' => 'admin#reset_break_counter'
    post '/kotodama/refill_codes' => 'admin#refill_codes'

    mount Sidekiq::Web => '/kotodama/sidekiq'
    mount RailsAdmin::Engine => '/kotodama/rails_admin', as: 'rails_admin'
    mount PgHero::Engine => '/kotodama/pghero'
    mount Kibana::Rack::Web => '/kibana'
  end

  mount API => '/'

  # Ember Tests
  mount EmberCLI::Engine => 'ember-tests' if Rails.env.development?
end
