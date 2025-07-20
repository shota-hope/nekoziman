class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :image_url
      t.text :description
      t.boolean :is_cat_image, default: false, null: false

      t.timestamps
    end
  end
end
