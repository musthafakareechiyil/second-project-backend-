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

    private 

    def user_params 
        params.require(:user).permit(:email, :phone, :fullname, :username, :password, :profile_url)
    end
end
