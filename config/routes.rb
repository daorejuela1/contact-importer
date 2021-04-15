Rails.application.routes.draw do
  root 'main#index'
  require 'sidekiq/web'

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :contacts, only: [:new, :create, :index] do
    collection { post :import }
  end
  resources :csv_uploads, only: [:new, :create, :index, :destroy]
  resources :csv_mapper, only: :new
end
