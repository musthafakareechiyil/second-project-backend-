class User::PostsController < ApplicationController
  include JSONAPI::Fetching

  def index
    page = params[:page] || 1

    @posts = Post.includes(:user).order(created_at: :desc).page(page).per(3)
    render json: @posts.as_json(
      only: [:id, :post_url, :caption],
      include: { user: { only: [:profile_url, :username] } }
    )
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

  def jsonapi_include
    super & ['users']
  end
end
