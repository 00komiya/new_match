Rails.application.routes.draw do
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

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

  namespace :admin do
    resources :items, only: [:index, :show, :destroy]
    resources :item_comments, only: [:destroy]
    resources :users, only: [:index, :show, :edit, :update]
  end

    # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip:[:registrations, :passwords],controllers:{
    sessions: "admin/sessions"
  }
    #ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

end
