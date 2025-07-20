FactoryBot.define do
  factory :post do
    user { nil }
    image_url { "MyString" }
    description { "MyText" }
    ai_comment { "MyText" }
    is_cat_image { false }
  end
end
