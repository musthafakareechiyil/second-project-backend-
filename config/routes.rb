Rails.application.routes.draw do

  namespace :user do
    resources :comments, only: [:index, :create]
    post ':username/follow_user', to: 'follow#follow_user'
    post ':username/unfollow_user', to: 'follow#unfollow_user'
    resources :users, only: [:create, :index, :show]
    patch 'update_profile', to: 'users#update_profile'
    post 'login', to: 'authentication#login'

    resources :posts, only: [:create, :index]
  end

  namespace :admin do
    post 'login', to: 'authentication#login'

    resources :usermanagment, only: [:index, :show, :destroy] do
      member do
        patch :block
        post :recover_user
      end
    end
    
  end



end
