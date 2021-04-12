Rails.application.routes.draw do
  get 'csv_mapper/new'
  get 'csv_uploads/new'
  get 'csv_uploads/upload'
  root 'main#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :contacts, only: [:new, :create, :index] do
    collection { post :import }
  end
  resources :csv_uploads, only: [:new, :create] do
    collection {post :upload}
  end
end
