class PostSerializer
  include JSONAPI::Serializer

  attributes :post_url, :caption
end
