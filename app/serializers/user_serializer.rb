class UserSerializer
  include JSONAPI::Serializer

  has_many :posts
end
