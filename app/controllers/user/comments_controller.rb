class User::CommentsController < ApplicationController
  def index
    page = params[:page] || 1
    @comments = Comment.includes(:user).order(created_at: :desc).page(page).per(5)
    render json: @comments.as_json(
      only: [:id, :body],
      include: { user: { only: [:profile_url, :username] } }
    )
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :body, :commentable_id, :commentable_type)
  end
end
