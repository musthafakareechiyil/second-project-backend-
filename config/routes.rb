Rails.application.routes.draw do

  namespace :user do
    resources :users, only: [:create]
    post 'login', to: 'authentication#login'
  end

  namespace :admin do
    post 'login', to: 'authentication#login'

    resources :usermanagment do
      member do
        post :block
        post :unblock
        post :recover_user
      end
    end
    
  end



end
