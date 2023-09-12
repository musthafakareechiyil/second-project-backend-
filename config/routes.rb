Rails.application.routes.draw do

  namespace :user do
    resources :users, only: [:create]
  end
  post 'user/login', to: 'user/authentication#login'

  post 'admin/login', to: 'admin/authentication#login'
end
