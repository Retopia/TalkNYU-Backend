class Api::V1::CommentsController < ApplicationController
  before_action :set_post

  def create
    comment = @post.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      render json: {
        message: "Added comment",
        comment: {
          post_id: @post.id,
          comment_id: comment.id,
          author: comment.user.username,
          body: comment.content,
          created_at: comment.created_at
        }
      }, status: :created
    else
      render json: { error: "Failed to comment" }, status: :unprocessable_entity
    end
  end

  def update
    comment = @post.comments.find_by(id: params[:comment_id], user: current_user)

    if comment&.update(comment_params)
      render json: { message: "Comment updated", comment: { body: comment.content, updated_at: comment.updated_at } }, status: :ok
    else
      render json: { error: "Update failed" }, status: :unprocessable_entity
    end
  end


  def destroy
    comment = @post.comments.find_by(id: params[:comment_id], user: current_user)
    
    if comment
      comment.destroy
      render json: { message: "Deleted comment" }, status: :ok
    else
      render json: { error: "Comment not found" }, status: :not_found
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
