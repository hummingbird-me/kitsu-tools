Rails.application.routes.draw do
  use_doorkeeper
  root to: "home#index"
end
