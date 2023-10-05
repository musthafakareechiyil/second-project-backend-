class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  validates :post_url, presence: true
end
