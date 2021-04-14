Rails.application.routes.draw do
  root 'main#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :contacts, only: [:new, :create, :index] do
    collection { post :import }
  end
  resources :csv_uploads, only: [:new, :create, :index, :destroy] do
    collection {post :upload}
  end
  resources :csv_mapper, only: :new
end
