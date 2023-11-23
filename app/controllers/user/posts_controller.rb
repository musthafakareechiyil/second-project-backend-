class User::PostsController < ApplicationController
  def index
    page = params[:page] || 1

    # array of following users with current_user id
    following_users = [@current_user.id] + @current_user.following.pluck(:id)

    # Fetch posts from following users only
    @posts = Post.includes(:user)
                 .where(user_id: following_users)
                 .order(created_at: :desc)
                 .page(page)
                 .per(3)

    posts = []

    @posts.each do |post|
      liked = @current_user.liked?(post)
      post_data = post.as_json(
        only: [:id, :post_url, :caption, :user_id],
        include: {
          user: { only: [:id, :profile_url, :username] }
        }
      )
      post_data["liked"] = liked
      post_data["likes_count"] = post.likes.count
      post_data["comments_count"] = post.comments.count

      posts << post_data
    end

    render json: {
      posts:
    }
  end

  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: {
        post: @post.as_json(
          include: { user: { only: [:id, :profile_url, :username] } }
        )
      }, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:post_url, :caption)
  end
end
