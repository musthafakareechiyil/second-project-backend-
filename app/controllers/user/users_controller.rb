class User::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    # before_action :find_user, only: %i[index]

    def index
        @users = User.where.not(id: @current_user.following.pluck(:id)).page(params[:page]).per(10)
        render json: @users
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
        params.require(:user).permit(:email, :phone, :fullname, :username, :password)
    end

    # def find_user
    #     @user = User.find(params[:id])
    # end
end
