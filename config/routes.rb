Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :my_credentials, only: [:new, :create, :index]
end
