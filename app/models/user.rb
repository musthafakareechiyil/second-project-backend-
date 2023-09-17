class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid

    validates :email, presence: true, uniqueness: true,format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { phone.nil? }
    validates :phone, presence: true, uniqueness: true,length: {minimum: 10}, if: -> { email.nil? }
    validates :fullname, presence: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: {minimum:8}
end
