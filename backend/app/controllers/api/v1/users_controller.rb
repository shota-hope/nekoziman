class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user, only: [:show, :update]
  before_action :check_owner, only: [:update]

  # GET /api/v1/users/:id
  def show
    render json: {
      user: user_json(@user, include_stats: true)
    }
  end

  # GET /api/v1/users/me
  def me
    render json: {
      user: user_json(current_user, include_stats: true, include_private_info: true)
    }
  end

  # PATCH/PUT /api/v1/users/:id
  def update
    if params[:profile_image].present?
      upload_result = upload_profile_image(params[:profile_image])
      unless upload_result[:success]
        render json: { errors: { profile_image: [upload_result[:error]] } }, status: :unprocessable_entity
        return
      end
      @user.profile_image_url = upload_result[:url]
    end

    if @user.update(user_params.except(:profile_image))
      render json: {
        user: user_json(@user, include_stats: true, include_private_info: true),
        message: 'プロフィールが更新されました'
      }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'ユーザーが見つかりません' }, status: :not_found
  end

  def check_owner
    unless @user == current_user
      render json: { error: '権限がありません' }, status: :forbidden
    end
  end

  def user_params
    params.permit(:username, :bio, :profile_image)
  end

  # プロフィール画像アップロード
  def upload_profile_image(file)
    begin
      result = Cloudinary::Uploader.upload(
        file,
        {
          folder: 'nekoziman/profiles',
          resource_type: 'image',
          format: 'jpg',
          quality: 'auto:good',
          transformation: [
            { width: 300, height: 300, crop: 'fill', gravity: 'face' },
            { quality: 'auto:good' }
          ]
        }
      )

      {
        success: true,
        url: result['secure_url'],
        public_id: result['public_id']
      }
    rescue => e
      Rails.logger.error "Profile image upload error: #{e.message}"
      { success: false, error: "アップロードに失敗しました: #{e.message}" }
    end
  end

  # JSON レスポンス用ヘルパーメソッド
  def user_json(user, include_stats: false, include_private_info: false)
    json = {
      id: user.id,
      username: user.username,
      bio: user.bio,
      profile_image_url: user.profile_image_url,
      created_at: user.created_at
    }

    if include_stats
      json[:stats] = {
        posts_count: user.posts.count
      }
    end

    if include_private_info
      json[:email] = user.email
      json[:provider] = user.provider
    end

    json
  end
end
