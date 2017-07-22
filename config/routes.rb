Rails.application.routes.draw do
  resources :app_modules
  resources :posts
  devise_for :users
end
