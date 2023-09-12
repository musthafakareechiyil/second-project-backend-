class User::AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def login 
        @user = if params[:email].present?
                    User.find_by_email(params[:email])
                elsif params[:phone].present?
                    User.find_by_phone(params[:phone])
                else
                    User.find_by_username(params[:username])
                end

        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { token: token, user: @user}, status: :ok
        else
            render json: { error: 'invalid credentials' }, status: :unauthorized
        end
    end
end
