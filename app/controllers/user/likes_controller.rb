class User::LikesController < ApplicationController
  def create
    likable_id = params[:likable_id]
    likable_type = params[:likable_type]

    liked = @current_user.like(likable_type, likable_id)

    if liked
      render json: { message: 'Liked', liked: true }
    else
      render json: { message: 'Dislike', liked: false }
    end
  end
end
