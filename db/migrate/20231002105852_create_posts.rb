class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :post_url, null: false
      t.text :caption
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :posts, :deleted_at
  end
end
