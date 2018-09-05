Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  root to: "top#index"
  resources :hunts, only: [:index, :new, :create, :show, :destroy, :edit, :update]
  resources :top, only: [:show]
end
