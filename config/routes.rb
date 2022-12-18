Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :users

  resources :items do
    resource :likes, only: [:create, :destroy]
   resources :item_comments, only: [:create, :destroy]
   resources :item_tags, only: [:destroy]
  end
end
