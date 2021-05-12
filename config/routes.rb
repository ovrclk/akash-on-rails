Rails.application.routes.draw do
  root to: 'pins#index'

  resources :pins
  resources :users

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
end
