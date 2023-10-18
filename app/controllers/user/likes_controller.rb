class User::LikesController < ApplicationController
  def index
    # Params
    likable_id = params[:likable_id]
    likable_type = params[:likable_type]

    # page params for pagination
    page = params[:page] || 1

    @likes = Like.where(likable_id:, likable_type:)
                 .includes(:user)
                 .page(page)
                 .per(20)

    # likes with user data
    render json: @likes.to_json(
      only: [:id, :user_id],
      include: {
        user: { only: [:id, :username, :profile_url, :fullname] }
      }
    )
  end

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
