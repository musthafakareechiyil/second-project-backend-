class AddProfileUrlToUsers < ActiveRecord::Migration[7.0]
  def change
    # adds a profile_url column to users with default url
    add_column :users, :profile_url, :string, default: "https://res.cloudinary.com/dbpcfcpit/image/upload/v1696350803/avatar-2_fv2tzx.webp"
  end
end
