Rails.application.routes.draw do

  # USER SIDE ROUTES
  namespace :user do
    # Routes for CommentsController
    resources :comments, only: [:index, :create]

    # Routes for FollowController
    get 'followers', to: 'follow#followers'
    post ':username/follow_user', to: 'follow#follow_user'
    post ':username/unfollow_user', to: 'follow#unfollow_user'

    # Routes for UsersController
    resources :users, only: [:create, :index]
    get 'user/:username', to: 'users#show'
    patch 'update_profile', to: 'users#update_profile'

    # Route for AuthenticationController
    post 'login', to: 'authentication#login'

    # Routes for PostsController
    resources :posts, only: [:create, :index, :destroy]

    # Routes for LikesController
    resources :likes, only: [:create, :index]

  end

  # ADMIN SIDE ROUTES
  namespace :admin do
    # Route for AuthenticationController
    post 'login', to: 'authentication#login'

    # Routes for UsermanagmentController
    resources :usermanagment, only: [:index, :show, :destroy] do
      member do
        patch :block
        post :recover_user
      end
    end
    
  end



end
