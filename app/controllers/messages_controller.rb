class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  # メッセージ送信
  def create
    @message = @chat.messages.new(message_params)
    @message.sender = current_user

    if @message.save
      MessageChannel.broadcast_to(@chat, {
        message_content: render_to_string(
          partial: "messages/message_content",
          locals: { message: @message }
        ),
        sender_id: @message.sender_id,
        content: @message.content, # ✅ メッセージ本文
        images: @message.images.map { |img| url_for(img) },
        files: @message.files.map { |file| { name: file.filename.to_s, url: url_for(file) } },
        timestamp: @message.created_at.strftime('%Y/%m/%d %H:%M') # ✅ 送信日時
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
end