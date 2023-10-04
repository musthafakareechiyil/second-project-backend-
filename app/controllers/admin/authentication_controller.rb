class Admin::AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def login
        @admin = Admin.find_by(email: params[:email])
        if @admin&.authenticate(params[:password])
            token = jwt_encode(admin_id: @admin.id)
            render json: { token: token,admin: @admin}, status: :ok
        else
            render json: { error: "invalid email or password" }, status: :unauthorized
        end
    end

end
