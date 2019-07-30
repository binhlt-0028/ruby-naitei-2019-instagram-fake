Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :posts, only: [:create, :destroy, :show, :edit, :update]
    resources :reactions, only: [:create, :destroy, :update]
    resources :comments, only: [:create, :destroy, :show, :edit, :update]
    get "signup", to: "users#new", as: "signup"
    get "login", to: "sessions#new", as: "login"
    post "login", to: "sessions#create", as: "sessions"
    get "logout", to: "sessions#destroy", as: "logout"
    resources :users
    resources :account_activations, only: :edit
  end
end
