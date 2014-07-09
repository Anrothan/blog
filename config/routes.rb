Rails.application.routes.draw do
  root to: "articles#index"
  resources :articles do
    resources :comments
  end
  resources :users
  resource :session, only: [:new, :create, :destroy]
  get '/login' => "sessions#new", :as => "login"
  get '/logout' => "sessions#destroy", :as => "logout"
end
