class Post < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  validates :image_url, presence: true
end
