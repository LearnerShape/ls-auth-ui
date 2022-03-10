Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :my_credentials, only: [:new, :create, :index]
  resources :my_invited_authentications do
    member do
      get 'accept'
      get 'refuse'
    end
  end
end
