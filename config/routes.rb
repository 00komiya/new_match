Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  get 'search' => 'searches#search'

  resources :users

  resources :items do
   resource :likes, only: [:create, :destroy]
  resources :item_comments, only: [:create, :destroy]
  end

end
