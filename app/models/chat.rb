class Chat < ApplicationRecord
  after_create { broadcast_message }
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true

  private

  def broadcast_message
    conversation_id = [sender_id, receiver_id].sort.join('_')
    ActionCable.server.broadcast("chat_#{conversation_id}", {
                                   id:,
                                   body:,
                                   receiver_id:,
                                   sender_id:
                                 })
  end
end
