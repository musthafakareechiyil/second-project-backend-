class User::SavedPostsController < ApplicationController
  def index
    saved_posts = @current_user.saved_posts.includes(:post)

    render json: saved_posts.as_json(include: [:post])
  end

  def create
    post = Post.find(params[:post_id])
    saved_post = @current_user.saved_posts.build(post:)

    if saved_post.save
      render json: { message: 'Post saved successfully' }, status: :created
    else
      render json: { error: 'Failed to save Post ' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { error: 'Post already saved' }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post with the given ID not found' }, status: :not_found
  end

  def destroy
    post = Post.find(params[:post_id])
    saved_post = @current_user.saved_posts.find_by(post:)

    if saved_post
      if saved_post.destroy
        render json: { message: 'Post removed from saved posts' }
      else
        render json: { error: 'Failed to remove from saved posts' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Post not saved yet' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post with given ID not found' }, status: :not_found
  end
end
