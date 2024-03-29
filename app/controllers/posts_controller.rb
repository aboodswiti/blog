class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[show index]
  # GET /posts or /posts.json
  def index
    @posts = Post.includes(:rich_text_body).all.order(created_at: :desc)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post.update(views: @post.views + 1)
    @comments = @post.comments.includes(:user, :rich_text_body).order(created_at: :desc)

    ahoy.track("Viewed Post", post_id: @post.id)
    
    mark_notifications_as_read


  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if params[:post][:images].present?
        params[:post][:images].each do |image|
          @post.images.attach(image)
        end
      end
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  # def update
  #   respond_to do |format|
  #     if @post.update(post_params)
  #       if params[:post][:images].present?
  #         params[:post][:images].each do |image|
  #           @post.images.attach(image)
  #         end
  #       end
  #       format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
  #       format.json { render :show, status: :ok, location: @post }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @post.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  def update
    respond_to do |format|
      if @post.update(post_params)
        # Delete attached images if requested
        if params[:post][:remove_images].present?
          params[:post][:remove_images].each do |image_id|
            @post.images.find_by(id: image_id)&.purge
          end
        end
        
        # Attach new images if present
        if params[:post][:images].present?
          params[:post][:images].each do |image|
            @post.images.attach(image)
          end
        end
  
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :category_id,)
    end

    def mark_notifications_as_read
      # current_user.notifications.mark_as_read


    end
end
