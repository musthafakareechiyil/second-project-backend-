class User::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]

    def create 
        @user = User.new(user_params)

        if @user.save 
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_message },
                   status: :unprocessable_entity
        end
    end

    private 

    def user_params 
        params.require(:user).permit(:email, :phone, :fullname, :username, :password)
    end
end
