class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    conversation_id = [params[:sender_id], params[:receiver_id]].sort.join('_')
    stream_from "chat_#{conversation_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
