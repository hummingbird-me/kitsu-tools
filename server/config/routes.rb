Rails.application.routes.draw do
  jsonapi_resources :library_entries
  jsonapi_resources :anime
  jsonapi_resources :users
  jsonapi_resources :characters
  jsonapi_resources :castings
  jsonapi_resources :genres
  jsonapi_resources :streamers
  jsonapi_resources :streaming_links
  jsonapi_resources :franchises
  jsonapi_resources :installments

  use_doorkeeper

  root to: 'home#index'
end
