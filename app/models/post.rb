class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  validates :user_id, presence: true
  validates :image_url, presence: true
end
