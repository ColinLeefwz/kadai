# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  get 'login', to: 'users/sessions#new'
  post 'login', to: 'users/sessions#create'
  delete 'logout', to: 'users/sessions#destroy'

  resources :images, only: %i[index new create]

  get 'oauth/callback', to: 'oauth#callback'
  get 'tweet', to: 'oauth#tweet'
end
