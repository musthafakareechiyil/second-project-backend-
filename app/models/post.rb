class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :saved_posts, dependent: :destroy

  validates :post_url, presence: true
end
