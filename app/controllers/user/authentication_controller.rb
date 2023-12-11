class User::AuthenticationController < ApplicationController
    include JwtToken
    skip_before_action :authenticate_request

    def login
        if params[:google_token]
            google_token = params[:google_token]
            id_token = Google::Auth::IDTokens.verify_oidc(google_token, aud:'908497929171-j1b1gpbd3vp8ct6vb2l4qbp9t3fe117e.apps.googleusercontent.com')

            if id_token
                email = id_token['email']
                @user = User.find_by(email: email)
                
                if @user
                    token = jwt_encode(user_id: @user.id)
                    render json: { token: token, user: @user}, status: :ok
                else
                    render json: { error: "User not registered" }, status: :unprocessable_entity
                end
            else
                render json: { error: 'Invalid Google token' }, status: :unauthorized
            end
            
        elsif params[:phone_token]
            phone_token = params[:phone_token]
            decoded = jwt_decode_rs256(phone_token)

            if decoded.key?(:phone_number)
                @user = User.find_by(phone: decoded[:phone_number])
                if @user
                    token = jwt_encode(user_id: @user.id)
                    render json: { token: token,user: @user}, status: :ok
                else
                    render json: { error: "User not registered" }, status: :unprocessable_entity
                end
            else
                render json: { error: "Invalid token" }, status: :unprocessable_entity
            end

        else
            @user = if params[:email].present?
                        User.find_by(email: params[:email])
                    elsif params[:phone].present?
                        User.find_by(phone: params[:phone])
                    else
                        User.find_by(username: params[:username])
                    end

            if @user&.authenticate(params[:password])
                token = jwt_encode(user_id: @user.id)
                render json: { token: token, user: @user}, status: :ok
            else
                render json: { error: 'invalid credentials' }, status: :unauthorized
            end
        end
    end
end
