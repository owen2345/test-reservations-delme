# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'dashboard#index'
  resources :reservations, except: :update do
    match :free_slots, on: :collection, via: %i[get post]
  end
end
