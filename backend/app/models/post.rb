class Post < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :image_url, presence: true
  validates :description, length: { maximum: 500 }
end
