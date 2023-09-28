class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id }
  validate :follower_is_not_following

  def follower_is_not_following
    errors.add(:follower, 'cannot follow yourself') if follower == following
  end
end
