class MessageChannel < ApplicationCable::Channel
  def subscribed
    @chat = Chat.find(params[:chat_id])
    stream_for @chat
  end

  def unsubscribed
    Rails.logger.info "❌ MessageChannel: クライアントが切断されました"
  end
end