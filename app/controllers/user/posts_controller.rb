class User::PostsController < ApplicationController
  include JSONAPI::Fetching

  def index
    page = params[:page] || 1

    following_users = [@current_user.id] + @current_user.following.pluck(:id)

    # Fetch posts from selected user IDs only
    @posts = Post.includes(:user)
                 .where(user_id: following_users)
                 .order(created_at: :desc)
                 .page(page)
                 .per(3)

    post_ids = @posts.map(&:id)

    # Fetch comment counts for the posts
    comment_counts = Comment.where(commentable_id: post_ids, commentable_type: 'Post')
                            .group(:commentable_id)
                            .count
    render json: {
      posts: @posts.as_json(
        only: [:id, :post_url, :caption, :user_id],
        include: { user: { only: [:id, :profile_url, :username] } }
      ),
      comment_counts:
    }
  end

  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: {
        post: @post.as_json(
        include: { user: { only: [:id, :profile_url, :username]}})
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

  def jsonapi_include
    super & ['users']
  end
end
