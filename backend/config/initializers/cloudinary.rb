require 'cloudinary'

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = Rails.env.production? # Use HTTPS in production
  config.cdn_subdomain = true # Use subdomain for faster loading
end
