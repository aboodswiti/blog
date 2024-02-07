class AdminController < ApplicationController
  def index
  
  end


  def posts
    # @posts = Post.all.includes(:user, :comments).order(created_at: :desc)
    @sort_by = params[:sort_by] || "id"
    @sort_order = params[:order] || "asc"
  
    @posts = Post.all.includes(:user, :comments)
                 .order("#{@sort_by} #{@sort_order}")
  end


  def comments
    @comments = Comment.all.includes(:user).order(created_at: :desc)

  end

  def users
    @users = User.all.includes(:posts, :comments).order(created_at: :desc)

  end

  def show_comment
    @comment = Comment.includes(:user).find(params[:id])
  end
  def show_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end
end
