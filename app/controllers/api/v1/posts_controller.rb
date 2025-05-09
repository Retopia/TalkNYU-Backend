class Api::V1::PostsController < ApplicationController
  def show
  end

  def index
    if params[:search].present?
      search_query = "%#{params[:search]}%"
      posts = Post.joins(:user).where(
        "posts.title ILIKE :q OR posts.body ILIKE :q OR users.username ILIKE :q",
        q: search_query
      ).includes(:user)
    else
      posts = Post.includes(:user, :likes, :comments)
    end
  
    posts = posts.order(created_at: :desc)
  
    posts_edited = posts.map do |post|
      {
        id: post.id,
        owner: post.user.username,
        title: post.title,
        body: post.body,
        created_at: post.created_at,
        likes: post.likes.size,
        comments: post.comments.size,
        has_liked: current_user ? (post.likes.any? { |like| like.user_id == current_user.id }) : false
      }
    end
  
    render json: posts_edited, status: :ok
  end

  def create
    post = current_user.posts.new(create_params)

    if post.save
      render json: {message: "Post created successfully"}, status: :ok
    else
      render json: {errors: post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def create_params
    params.permit(:title, :body)
  end
end
