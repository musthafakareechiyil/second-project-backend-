class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :post_url, presence: true
end
