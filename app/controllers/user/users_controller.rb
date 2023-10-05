class User::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]

    def index
        @users = User.where.not(id: @current_user.following.pluck(:id)).page(params[:page]).per(10)
        render json: @users
    end

    def show
        following_count = @current_user.following.count
        followers_count = @current_user.followers.count
        post_count = @current_user.posts.count

        render json: {
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
