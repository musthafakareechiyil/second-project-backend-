class Chat < ApplicationRecord
  after_create { broadcast_message }
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  private

  def broadcast_message
    conversation_id = [sender_id, receiver_id].sort.join('_')
    ActionCable.server.broadcast("chat_#{conversation_id}", {
      id:,
      body:,
      receiver_id:,
      sender_id:,
    })
  end
end
