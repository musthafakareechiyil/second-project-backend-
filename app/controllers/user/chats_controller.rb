class User::ChatsController < ApplicationController
  def index
    sender_id = @current_user.id
    receiver_id = params[:receiver_id]
    @chat_history = Chat.where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)", sender_id, receiver_id, receiver_id, sender_id)
                        .order(:created_at)

    render json: @chat_history
  end

  def create
    sender = @current_user
    @chat = Chat.new(message_params.merge(sender:))
    if @chat.save
      # ActionCable.server.broadcast("chat_#{sender.id}#{params[:chat][:receiver_id]}", @chat.as_json)
      render json: @chat, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def chatted_users
    sent_users = User.joins(:sent_chat)
                     .where(chats: { receiver_id: @current_user.id })
                     .select('users.id')
    received_users = User.joins(:received_chat)
                         .where(chats: { sender_id: @current_user.id })
                         .select('users.id')
    chatted_users = User.where(id: sent_users).or(User.where(id: received_users)).distinct

    render json: chatted_users
  end

  private

  def message_params
    params.require(:chat).permit(:body, :receiver_id)
  end
end
