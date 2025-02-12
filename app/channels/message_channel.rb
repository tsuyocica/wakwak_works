class MessageChannel < ApplicationCable::Channel
  def subscribed
    @chat = Chat.find(params[:chat_id])
    stream_for @chat # ✅ 正しくストリームする
    Rails.logger.info "✅ MessageChannel: #{@chat.id} にストリーム開始"
  end

  def unsubscribed
    Rails.logger.info "❌ MessageChannel: クライアントが切断されました"
  end
end