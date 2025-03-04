# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :users do
    get '/dashboard/index',   to: 'dashboard#index'
    get '/dashboard/reports', to: 'dashboard#reports'
    get '/survivors/index',   to: 'survivors#index'
    resources :infections, only: [:create]
  end

  resources :items

  resources :trades, only: %i[index new create update] do
    resources :trade_histories, only: [:index]
  end

  resources :locations, only: %i[new create index]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'home#index'
end
