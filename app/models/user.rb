class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid

    validates :email, presence: true, uniqueness: true,format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { phone.nil? }
    validates :phone, presence: true, uniqueness: true,length: {minimum: 10}, if: -> { email.nil? }
    validates :fullname, presence: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: {minimum:8}

    has_many :follower_relation, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy, inverse_of: :following
    has_many :followers, through: :follower_relation, source: :follower

    has_many :following_relation, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
    has_many :following, through: :following_relation, source: :following

    def follow(other_user)
        follower_relation.create(follower_id: other_user.id)
    end

    def unfollow(other_user)
        follower_relation.find_by(follower_id: other_user.id)&.destroy
    end

    def following?(other_user)
        following.include?(other_user)
    end
end
