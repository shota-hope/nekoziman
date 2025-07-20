class AddPublicIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :public_id, :string
  end
end
