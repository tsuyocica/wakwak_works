class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  # メッセージ送信
  def create
    @message = @chat.messages.new(message_params)
    @message.sender = current_user

    if @message.save
      # ✅ WebSocket でメッセージを送信（current_user を渡さない）
      MessageChannel.broadcast_to(@chat, {
        message_html: render_message(@message, current_user.id),
      })
    end

    # ✅ TurboStream用のレスポンス
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chat_path(@chat) }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content, images: [], files: [])
  end

  # ✅ `current_user` を渡さず、`sender_id` を明示的に渡す
  def render_message(message, sender_id)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message, sender_id: sender_id }
    )
  end
end