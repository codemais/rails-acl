Rails.application.routes.draw do
  resources :profiles
  resources :home, only: [:index]
  root to: 'home#index'
  resources :posts
  devise_for :users
end
