class Admin::UsermanagmentController < ApplicationController
    before_action :authenticate_admin
    before_action :find_user, only: [:show,:destroy,:block,:recover_user]

    def index
        @users = User.with_deleted.order(created_at: :asc).page(params[:page]).per(10)
        render json: @users
    end

    def show
        render json: @user
    end

    def destroy 
        @user.destroy 
        head :no_content
    end

    def block 
        # rubocop:disable Rails/SkipsModelValidations
        @user.update_column(:blocked, !@user.blocked)
        # rubocop:enable Rails/SkipsModelValidations
        if @user.blocked?
            render json: @user, notice: 'User blocked'
        else
            render json: @user, notice: 'User unblocked'
        end
    end

    def recover_user
        @user.recover
        @user.save(validate: false)
        render json: @user, notice: 'User restored successfully'
    end

    private 

    def user_params 
        params.require(:user).permit(:email,:phone,:password,:username,:fullname)
    end

    def find_user 
        @user = User.with_deleted.find(params[:id])
    end
end
