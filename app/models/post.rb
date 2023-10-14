class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy

  validates :post_url, presence: true

  delegate :count, to: :likes, prefix: true

  delegate :count, to: :comments, prefix: true
end
