Rails.application.routes.draw do

  # USER SIDE ROUTES
  namespace :user do
    # Routes for CommentsController
    resources :comments, only: [:create, :index]

    # Routes for FollowController
    get 'followers', to: 'follow#followers'
    get 'following', to: 'follow#following'
    post ':username/follow_user', to: 'follow#follow_user'
    post ':username/unfollow_user', to: 'follow#unfollow_user'

    # Routes for UsersController
    resources :users, only: [:create, :index]
    get 'user/:username', to: 'users#show'
    patch 'update_profile', to: 'users#update_profile'
    get 'search', to: 'users#search'

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
