class Post < ApplicationRecord
  belongs_to :user

  validates :image_url, presence: true
  validates :description, length: { maximum: 500 }
  validates :public_id, presence: true

  before_destroy :delete_cloudinary_image

  def upload_image(file)
    result = ImageUploadService.upload_image(file)

    if result[:success]
      self.image_url = result[:url]
      self.public_id = result[:public_id]
      result
    else
      errors.add(:image_url, result[:error])
      result
    end
  end

  def thumbnail_url(size = 200)
    return nil unless public_id.present?

    ImageUploadService.generate_image_url(
      public_id,
      width: size,
      height: size,
      crop: 'fill',
      quality: 'auto:good'
    )
  end

  def medium_url
    return nil unless public_id.present?

    ImageUploadService.generate_image_url(
      public_id,
      width: 600,
      height: 600,
      crop: 'fit',
      quality: 'auto:good'
    )
  end

  private

  def delete_cloudinary_image
    if public_id.present?
      ImageUploadService.delete_image(public_id)
    end
  end
end
