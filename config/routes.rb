# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'dashboard#index'
  # health checker
  resources :health_checks, only: [] do
    get :liveness, on: :collection
    get :readiness, on: :collection
  end

  # auth 0
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
  get '/auth/login' => 'auth0#login'
end
