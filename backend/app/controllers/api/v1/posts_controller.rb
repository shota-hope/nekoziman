class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

    # GET /api/v1/posts or /api/v1/users/:user_id/posts
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @posts = user.posts.preload(:user).recent
    else
      @posts = Post.preload(:user).recent
    end

    @posts = @posts.page(params[:page]).per(20)

    render json: {
      posts: posts_json(@posts),
      meta: pagination_meta(@posts)
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'ユーザーが見つかりません' }, status: :not_found
  end

  # GET /api/v1/posts/:id
  def show
    render json: {
      post: post_json(@post, include_user: true)
    }
  end

  # POST /api/v1/posts
  def create
    @post = current_user.posts.build(post_params.except(:image))

    if params[:image].present?
      upload_result = @post.upload_image(params[:image])
      unless upload_result[:success]
        render json: { errors: @post.errors }, status: :unprocessable_entity
        return
      end
    end

    if @post.save
      render json: {
        post: post_json(@post, include_user: true),
        message: '投稿が作成されました'
      }, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/posts/:id
  def update
    if params[:image].present?
      upload_result = @post.upload_image(params[:image])
      unless upload_result[:success]
        render json: { errors: @post.errors }, status: :unprocessable_entity
        return
      end
    end

    if @post.update(post_params.except(:image))
      render json: {
        post: post_json(@post, include_user: true),
        message: '投稿が更新されました'
      }
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy
    render json: { message: '投稿が削除されました' }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '投稿が見つかりません' }, status: :not_found
  end

  def check_owner
    unless @post.user == current_user
      render json: { error: '権限がありません' }, status: :forbidden
    end
  end

  def post_params
    params.permit(:description, :image)
  end

    # JSON レスポンス用ヘルパーメソッド
  def posts_json(posts)
    posts.map { |post| post_json(post, include_user: true) }
  end

  def post_json(post, include_user: false)
    json = {
      id: post.id,
      description: post.description,
      image_url: post.medium_url || post.image_url,
      thumbnail_url: post.thumbnail_url,
      is_cat_image: post.is_cat_image,
      created_at: post.created_at,
      updated_at: post.updated_at
    }

    if include_user
      json[:user] = {
        id: post.user.id,
        username: post.user.username,
        profile_image_url: post.user.profile_image_url
      }
    end

    json
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      first_page?: collection.first_page?,
      last_page?: collection.last_page?
    }
  end
end
