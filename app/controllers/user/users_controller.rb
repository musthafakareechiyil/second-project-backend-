class User::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]

    def index
      # suggesting users to follow according to posts count
      @users = User.where.not(id: @current_user.following.pluck(:id))
                   .joins('LEFT JOIN posts ON users.id = posts.user_id')
                   .group('users.id')
                   .order('COUNT(posts.id) DESC')
                   .page(params[:page])
                   .per(10)

      render json: @users
    end

    def show
      @user = User.find_by(username: params[:username])
      posts = @user.posts.order(created_at: :desc)
      following_count = @user.following.count
      followers_count = @user.followers.count
      post_count = @user.posts.count
      is_following = @current_user.following?(@user)
    
      # Create an array to store posts with 'liked?, likes_count and comments_count' information
      posts_with_liked = []
      # iterating over posts
      posts.each do |post|
            
        liked = @current_user.liked?(post)
        likes_count = post.likes.count
        comments_count = post.comments.count

        posts_with_liked.push(
          id: post.id,
          user_id: post.user_id,
          post_url: post.post_url, 
          caption: post.caption, 
          likes_count:, 
          comments_count:, 
          liked:
        )
      end
    
      render json: {
        user: @user.as_json(
          only: [:id, :email, :phone, :username, :profile_url, :fullname]
        ),
        posts: posts_with_liked, 
        following_count:,
        followers_count:,
        post_count:,
        is_following:
      }        
    end
    
    def create 
        @user = User.new(user_params)
        @user.phone = "+91"+@user.phone if @user.phone.present?
        if @user.save 
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
                   status: :unprocessable_entity
        end
    end

    def update_profile
        if params[:profile_url].present?
          # rubocop:disable Rails/SkipsModelValidations
          if @current_user.update_columns(profile_url: params[:profile_url])
            # rubocop:enable Rails/SkipsModelValidations
            render json: @current_user
          else
            render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: 'Missing profile_url parameter' }, status: :unprocessable_entity
        end
    end

    def search
      page = params[:page]
      key = params[:key].downcase
      @user = User.where("username LIKE ?", "%#{key}%").order(created_at: :desc)
                  .page(page)
                  .per(10)
                  
      render json: @user.to_json(
        only: [:id, :username, :profile_url, :fullname]
      )
    end

    private 

    def user_params 
        params.require(:user).permit(:email, :phone, :fullname, :username, :password, :profile_url)
    end
end
