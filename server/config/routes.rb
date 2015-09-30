Rails.application.routes.draw do
  resources :users, except: [:new, :edit, :index]
  use_doorkeeper

  root to: "home#index"
end
