class User::CommentsController < ApplicationController
  def index
    page = params[:page] || 1
    @post = Post.find(params[:id])
    @comment = @post.comments
                    .includes(:user)
                    .order(created_at: :desc)
                    .page(page)
                    .per(10)

    render json: @comment.to_json(
      only: [:id, :user_id, :body, :commentable_id, :commentable_type, :created_at],
      include: {
        user: { only: [:id, :username, :profile_url] }
      }
    )
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: @comment.to_json(
        include: { user: { only: [:id, :username, :profile_url] } }
      )
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :body, :commentable_id, :commentable_type)
  end
end
