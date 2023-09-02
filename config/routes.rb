Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :my_credentials, only: [:new, :create, :index] do
    member do
      get 'add_authenticators_form'
      post 'add_authenticators'
      get 'add_logo_form'
      post 'add_logo'
    end
  end
  resources :credentials_for_others, only: [:new, :create, :index] do
    member do
      get 'add_participants_form'
      post 'add_participants'
      get 'add_logo_form'
      post 'add_logo'
      get 'revoke'
    end
  end
  resources :my_invited_authentications do
    member do
      get 'accept'
      get 'refuse'
    end
  end
  resources :public_views, only: [:new, :create, :index, :show] do
    member do
      get 'mark_inactive'
      get 'mark_active'
    end
  end
end
