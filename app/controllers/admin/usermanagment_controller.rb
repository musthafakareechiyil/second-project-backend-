class Admin::UsermanagmentController < ApplicationController
    before_action :authenticate_admin
    before_action :find_user, only: [:show,:update,:destroy,:block ,:unblock]

    def index
        @users = User.all
        render json: @users
    end

    def show
        render json: @user
    end

    def create 
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params)
            render json: @user, notice: 'User updated successfully'
        else
            render json: @user.errors 
        end
    end

    def destroy 
        @user.destroy 
        head :no_content
    end

    def block 
        if @user.update(blocked: true)
            render json: @user, notice: 'User blocked!'
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end
    
    def unblock
        if @user.update(blocked: false)
            render json: @user, notice: 'User unblocked!'
        else
            render json: @user.errors, statsu: :unprocessable_entity
        end
    end

    private 

    def user_params 
        params.require(:user).permit(:email,:phone,:password,:usermame,:fullname)
    end

    def find_user 
        @user = User.find(params[:id])
    end
end
