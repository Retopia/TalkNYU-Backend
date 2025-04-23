class Api::V1::PostsController < ApplicationController
  def show
  end

  def index
    if params[:search].present?
      posts_search = Post.where("title ILIKE ? OR body ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      posts_search = Post.all
    end

    posts = posts_search.includes(:user).order(created_at: :desc)
    posts_edited = posts.map do |post|
      {
        id: post.id,
        owner: post.user.username,
        title: post.title,
        body: post.body,
        created_at: post.created_at
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
