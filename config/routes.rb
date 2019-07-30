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
    resources :follow_users, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :users
    resources :account_activations, only: :edit
    resources :admin, only: :create
    namespace :admin do
      root "users#index"
      resources :users, only: %i(destroy index)
      resources :posts, only: %i(destroy index)
      get "block_user/:id", to: "users#block", as: "block_user"
      get "block_post/:id", to: "posts#block", as: "block_post"
      get "login", to: "sessions#new", as: "login"
      post "sessions", to: "sessions#create", as: "sessions"
      get "logout", to: "sessions#destroy", as: "logout"
    end
  end
end
