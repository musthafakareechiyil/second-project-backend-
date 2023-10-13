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

        render json: {
          user: @user.as_json,
          posts:,
          following_count:,
          followers_count:,
          post_count:
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

    private 

    def user_params 
        params.require(:user).permit(:email, :phone, :fullname, :username, :password, :profile_url)
    end
end
