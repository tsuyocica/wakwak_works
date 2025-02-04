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

  # チャットルーム作成（施工管理者 or 作業員）
  def create
    job_post = JobPost.find_by(id: params[:job_post_id])
    worker = User.find_by(id: params[:worker_id])

    # 無効なリクエストを防ぐ
    if job_post.nil? || worker.nil?
      Rails.logger.error "⚠️ 無効なリクエスト: job_post_id=#{params[:job_post_id]}, worker_id=#{params[:worker_id]}"
      redirect_to chats_path, alert: "無効なリクエストです。" and return
    end

    # すでにチャットルームがある場合 → 既存のルームにリダイレクト
    chat = Chat.find_by(job_post: job_post, worker: worker)
    if chat
      Rails.logger.info "✅ 既存のチャットルームに遷移: chat_id=#{chat.id}"
      redirect_to chat_path(chat) and return
    end

    # 新規作成
    chat = Chat.create!(job_post: job_post, owner: job_post.user, worker: worker)
    Rails.logger.info "✅ 新しいチャット作成: chat_id=#{chat.id}, owner_id=#{chat.owner.id}, worker_id=#{chat.worker.id}"

    redirect_to chat_path(chat), notice: "チャットルームを作成しました。"
  end

  private

  # 特定のチャットルームを取得
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # `@chat_list` を取得（index/show 共通）
  def fetch_chat_list
    if current_user.role.include?("施工管理者")
      # 施工管理者 → 自分の案件に紐づいた **承認済み** の作業員
      Chat.joins(:job_post)
          .where(job_posts: { user_id: current_user.id })
          .where.not(worker_id: nil)
          .includes(:worker)
          .order(updated_at: :desc) # 🔹 最新のチャットを上にする
    else
      # 作業員 → 自分が応募した案件（承認済み）の **案件名 + 管理者**
      Chat.joins(:job_post)
          .where(worker_id: current_user.id)
          .includes(:owner, :job_post)
          .order(updated_at: :desc) # 🔹 最新のチャットを上にする
    end
  end
end