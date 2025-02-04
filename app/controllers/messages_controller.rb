class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  # メッセージ送信
  def create
    @message = @chat.messages.new(message_params)
    @message.sender = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(@chat), notice: "メッセージを送信しました。" }
        format.json # ここでJS側と連携（後で実装）
      end
    else
      respond_to do |format|
        format.html { redirect_to chat_path(@chat), alert: "メッセージの送信に失敗しました。" }
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
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