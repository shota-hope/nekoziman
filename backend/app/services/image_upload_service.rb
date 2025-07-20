class ImageUploadService
  include Cloudinary::Utils

  def self.upload_image(file, options = {})
    return { error: 'No file provided' } if file.blank?

    begin
      result = Cloudinary::Uploader.upload(
        file,
        {
          folder: 'nekoziman/posts',        # フォルダ名
          resource_type: 'image',           # 画像のみ許可
          format: 'jpg',                    # JPGに統一
          quality: 'auto:good',             # 品質最適化
          transformation: [
            { width: 800, height: 800, crop: 'fill' },  # 正方形にクロップ
            { quality: 'auto:good' }        # 品質調整
          ]
        }.merge(options)
      )

      {
        success: true,
        url: result['secure_url'],
        public_id: result['public_id'],
        width: result['width'],
        height: result['height']
      }
    rescue => e
      Rails.logger.error "Image upload error: #{e.message}"
      { error: "Upload failed: #{e.message}" }
    end
  end

  def self.delete_image(public_id)
    return { error: 'No public_id provided' } if public_id.blank?

    begin
      result = Cloudinary::Uploader.destroy(public_id)
      { success: true, result: result }
    rescue => e
      Rails.logger.error "Image deletion error: #{e.message}"
      { error: "Deletion failed: #{e.message}" }
    end
  end

  def self.generate_image_url(public_id, options = {})
    return nil if public_id.blank?

    cl_image_url(
      public_id,
      {
        secure: true,
        quality: 'auto:good',
        fetch_format: 'auto'
      }.merge(options)
    )
  end

  private

  def self.validate_image_file(file)
    allowed_types = %w[image/jpeg image/jpg image/png image/gif]
    max_size = 10.megabytes

    return 'Invalid file type' unless allowed_types.include?(file.content_type)
    return 'File too large (max 10MB)' if file.size > max_size

    nil
  end
end
