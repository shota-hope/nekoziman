class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # 関連付け
  has_many :posts, dependent: :destroy
  has_many :cats, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # バリデーション
  validates :username, presence: true, uniqueness: true,
            length: { maximum: 30 }

  # OAuth用メソッド
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = generate_username_from_google(auth.info.name)
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  # デフォルトのプロフィール画像URL
  def profile_image_url
    super || '/images/default_cat_avatar.png'
  end

  private

  def self.generate_username_from_google(name)
    # Googleの名前からユーザー名を生成し、重複を避ける
    base_username = name.to_s.gsub(/[^a-zA-Z0-9\p{Hiragana}\p{Katakana}\p{Han}]/, '')
    base_username = base_username.truncate(25, omission: '')
    base_username = 'user' if base_username.blank?

    username = base_username
    counter = 1
    while User.exists?(username: username)
      username = "#{base_username}_#{counter}"
      counter += 1
    end
    username
  end
end
