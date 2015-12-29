Rails.application.routes.draw do
  jsonapi_resources :library_entries
  jsonapi_resources :anime
  jsonapi_resources :users
  jsonapi_resources :characters
  jsonapi_resources :castings

  use_doorkeeper

  root to: 'home#index'
end
