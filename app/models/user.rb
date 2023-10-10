class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    validates :email, presence: true, uniqueness: true,format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { phone.nil? }
    validates :phone, presence: true, uniqueness: true,length: {minimum: 10}, if: -> { email.nil? }
    validates :fullname, presence: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: {minimum:8}
    validate :username_format

    def username_format
        return unless username.present? && (username != username.downcase || username.match(/\s/))

        errors.add(username, "username must be in downcase and cannot contain spaces")
    end

    has_many :follower_relation, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy, inverse_of: :following
    has_many :following, through: :follower_relation, source: :follower

    has_many :following_relation, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
    has_many :followers, through: :following_relation, source: :following

    def follow(other_user)
        follower_relation.create(follower_id: other_user.id)
    end

    def unfollow(other_user)
        follower_relation.find_by(follower_id: other_user.id)&.destroy
    end

    def following?(other_user)
        following_ids.include?(other_user)
    end
end
