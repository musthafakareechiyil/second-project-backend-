class ApplicationController < ActionController::API
    include JwtToken

    before_action :authenticate_request

    private

    def authenticate_request
        header = request.headers["Authorization"]

        if header
            token = header.split[1]
            decoded = jwt_decode(token)

            if decoded.key?(:user_id)
                @current_user = User.find(decoded[:user_id])
            elsif decoded.key?(:admin_id)
                @admin = Admin.find(decoded[:admin_id])
            else
                render json: { error: "invalid token" }, status: :unauthorized
            end
            
        else
            render json: { error:"unauthorized" }, status: :unauthorized
        end
    end

    protected

    def authenticate_admin
        unless @admin 
            render json: { error: 'Admin authentication required' },status: :unauthorized
        end
    end

end
