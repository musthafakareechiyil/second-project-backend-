class User::LikesController < ApplicationController
  def create
    likable_id = params[:likable_id]
    likable_type = params[:likable_type]

    if @current_user.like(likable_type, likable_id)
      render json: { message: 'reuquest success' }
    else
      render json: { errors: @like.errors.full_messages }, status: :unauthorized
    end
  end
end
