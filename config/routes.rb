Rails.application.routes.draw do
  get 'csv_uploads/new'
  root 'main#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :contacts, only: [:new, :create]
  resources :csv_uploads, only: [:new, :create]
end
