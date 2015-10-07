Rails.application.routes.draw do
  resources :anime, except: %i[new edit]
  resources :users, except: %i[new edit index]

  use_doorkeeper

  root to: 'home#index'
end
