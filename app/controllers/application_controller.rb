class ApplicationController < ActionController::API
    include JwtToken

    before_action :authenticate_request

    private

    def authenticate_request
        header = request.headers["Authorization"]

        if header
            token = header.split(" ")
            decoded = jwt_decode(token)

            if decoded.key?(:user_id)
                @user = User.find(decoded[:user_id])
            elsif decoded.key?(:admin_id)
                @admin = Admin.find(decoded[:admin_id])
            else
                render json: { error: "invalid token" }, status: :unauthorized
            end
            
        else
            render json: { error:"unauthorized" }, status: :unauthorized
        end

    end

    # def authenticate_request
    #     header = request.headers["Authorization"]
    #     header = header.split(" ").last if header
    #     decoded = jwt_decode(header)
    #     @user = User.find(decoded[:user_id])
    #     @admin = Admin.find(decoded[:admin_id])
    # end

end
