class Api::V1::LikesController < ApplicationController
  before_action :set_post

  def create
    like = @post.likes.find_or_initialize_by(user: current_user)
    if like.persisted?
      render json: { message: "Already liked" }, status: :ok
    elsif like.save
      render json: { message: "Liked" }, status: :created
    else
      render json: { error: "Failed to like" }, status: :unprocessable_entity
    end
  end

  def destroy
    like = @post.likes.find_by(user: current_user)
    if like
      like.destroy
      render json: { message: "Unliked" }, status: :ok
    else
      render json: { error: "Like not found" }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
