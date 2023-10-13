class User::LikesController < ApplicationController
  def create
    @like = Like.new(likes_params)
    @like.user = @current_user

    if @like.save
      render json: @like, status: :created
    else
      render json: { errors: @like.errors.full_messages }, status: :unauthorized
    end
  end

  private

  def likes_params
    params.require(:likes).permit(:likable_id, :likable_type)
  end
end
