class User::FollowController < ApplicationController
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
    render json: @followers.to_json(
      only: [:id, :username, :profile_url, :fullname]
    )
  end

  def follow_user
    @other_user = User.find_by! username: params[:username]

    if @current_user.follow @other_user
      render json: @other_user, status: :ok
    else
      render json: @other_user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def unfollow_user
    @other_user = User.find_by! username: params[:username]
    if @current_user.unfollow @other_user
      render json: @other_user, status: :ok
    else
      render json: @other_user.errors.full_messages, status: :unprocessable_entity
    end
  end
end
