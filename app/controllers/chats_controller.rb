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

  # チャットルーム作成（施工管理者または作業員）
  def create
    job_post = JobPost.find_by(id: params[:job_post_id])
    worker = User.find_by(id: params[:worker_id])

    unless job_post && worker
      Rails.logger.error "⚠️ 無効なリクエスト: job_post_id=#{params[:job_post_id]}, worker_id=#{params[:worker_id]}"
      redirect_to chats_path, alert: "無効なリクエストです。" and return
    end

    Rails.logger.info "✅ チャット作成: job_post_id=#{job_post.id}, owner_id=#{job_post.user.id}, worker_id=#{worker.id}"

    # すでにチャットルームがある場合はリダイレクト
    chat = Chat.find_or_create_by!(job_post: job_post, owner: job_post.user, worker: worker)

    Rails.logger.info "✅ 作成されたチャット: chat_id=#{chat.id}, worker_id=#{chat.worker_id}"

    redirect_to chat_path(chat), notice: "チャットルームを作成しました。"
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  # `@chat_list` を取得（index/show 共通）
  def fetch_chat_list
    if current_user.role.include?("施工管理者")
      Chat.joins(:job_post)
          .where(job_posts: { user_id: current_user.id })
          .where.not(worker_id: nil)
          .includes(:worker)
    else
      Chat.joins(:job_post)
          .where(worker_id: current_user.id)
          .includes(:owner)
    end
  end
end