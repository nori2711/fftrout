Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  root to: "top#index"
  resources :hunts, only: [:index, :new, :create, :show, :destroy, :edit, :update]
  resources :top, only: [:show]

  # 問合せ機能のルーティング
  get 'inquiry' => 'inquiry#index'              # 入力画面
  get 'inquiry/show' => 'inquiry#show'          # Q&A画面
  post 'inquiry/confirm' => 'inquiry#confirm'   # 確認画面
  post 'inquiry/thanks' => 'inquiry#thanks'     # 送信完了画面
end
