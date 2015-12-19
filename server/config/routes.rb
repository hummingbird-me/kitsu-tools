Rails.application.routes.draw do
  jsonapi_resources :library_entries
  jsonapi_resources :anime
  jsonapi_resources :users

  use_doorkeeper

  root to: 'home#index'
end
