Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :posts, only: [:create, :destroy, :show, :edit, :update]
    resources :reactions, only: [:create, :destroy, :update]
    resources :comments, only: [:create, :destroy, :show, :edit, :update]
  end
end
