class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show]

  # チャット一覧
  def index
    @chat_list = fetch_chat_list
  end

  # 個別チャットルーム（メッセージ表示）
  def show
    @chat_list = fetch_chat_list
    @messages = @chat.messages.includes(:sender) # メッセージを取得
    @partner = @chat.owner == current_user ? @chat.worker : @chat.owner # チャット相手を取得
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  # `@chat_list` を取得（index/show 共通）
  def fetch_chat_list
    if current_user.role.include?("施工管理者")
      # 施工管理者 → 自分が作成した `job_post` に紐づく **承認済みの `workers`** を取得
      Chat.joins(:job_post)
          .where(job_posts: { user_id: current_user.id })
          .where.not(worker_id: nil)
          .includes(:worker)
    else
      # 作業員 → 自分が応募して承認された `job_post` + `owner` を取得
      Chat.joins(:job_post)
          .where(worker_id: current_user.id)
          .includes(:owner)
    end
  end
end