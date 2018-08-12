Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update]
  root to: "top#index"
  resources :hunts, only: [:index, :new, :create, :show]
  resources :top, only: [:show]
end
