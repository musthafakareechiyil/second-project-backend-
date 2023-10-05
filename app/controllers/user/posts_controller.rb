class User::PostsController < ApplicationController

  def index
    @posts = Post.order(created_at: :desc).all
    render json: @posts
  end

  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_url, :caption)
  end
end
