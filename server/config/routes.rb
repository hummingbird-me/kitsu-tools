Rails.application.routes.draw do
  resources :users, except: %i[new edit index]
  use_doorkeeper

  root to: 'home#index'
end
