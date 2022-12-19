Rails.application.routes.draw do
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"

  devise_for :user
    # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip:[:registrations, :passwords],controllers:{
    sessions: "admin/sessions"
  }
    #ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # 会員の退会確認画面,退会処理
  get "/users/quit" => "users#quit"
  patch "/users/out" => "users#out"

  resources :notifications, only: [:index, :destroy]

  resources :users do
    member do
      get :likes
    end
  end

  resources :items do
    resource :likes, only: [:create, :destroy]
   resources :item_comments, only: [:create, :destroy]
   resources :item_tags, only: [:destroy]
  end



end
