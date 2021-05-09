Rails.application.routes.draw do
  root to: 'pins#index'

  resources :pins
end
