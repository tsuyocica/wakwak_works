class JobPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index] # 🔹 ログイン必須
  before_action :set_job_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy] # 🔹 投稿者本人のみ編集・削除可

  # ✅ 作業案件一覧ページ
  def index
    @q = JobPost.ransack(params[:q]) # 🔍 Ransack検索オブジェクト
    @job_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc) # 🔹 検索結果
  end

  # ✅ 作業案件詳細ページ
  def show
  end

  # ✅ 新規投稿ページ
  def new
    @job_post = JobPost.new
  end

  # ✅ 案件作成処理
  def create
    @job_post = current_user.job_posts.build(job_post_params) # 🔹 ログインユーザーの投稿として作成
    if @job_post.save
      redirect_to @job_post, notice: "案件を作成しました！"
    else
      flash.now[:alert] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  # ✅ 編集ページ
  def edit
  end

  # ✅ 案件更新処理
  def update
    # **削除フラグがONの場合、画像を削除**
    if params[:job_post][:remove_main_image] == "true"
      @job_post.main_image.purge if @job_post.main_image.attached?
    end

    # **データ更新**
    if @job_post.update(job_post_params)
      redirect_to @job_post, notice: "案件を更新しました！"
    else
      flash.now[:alert] = "入力内容に誤りがあります"
      render :edit, status: :unprocessable_entity
    end
  end

  # ✅ 案件削除処理（施工管理者のみ）
  def destroy
    @job_post.destroy
    redirect_to job_posts_path, notice: "案件を削除しました。"
  end

  # ✅ 応募者一覧ページ
  def applicants
    @job_post = JobPost.find(params[:id])
    @applicants = @job_post.job_applications.includes(:worker) # 🔹 応募者情報を取得
  end

  private

  # ✅ ID から案件情報を取得
  def set_job_post
    @job_post = JobPost.find_by(id: params[:id])
    unless @job_post
      redirect_to job_posts_path, alert: "該当する案件が見つかりません。"
    end
  end

  # ✅ 権限チェック（投稿者のみ編集・削除可能）
  def authorize_user!
    unless current_user == @job_post.user
      redirect_to job_posts_path, alert: "この操作は許可されていません。"
    end
  end

  # ✅ Strong Parameters（許可するパラメータ）
  def job_post_params
    params.require(:job_post).permit(:work_title, :work_description, :work_capacity, :work_start_date, :work_end_date, :work_payment, :work_location, :work_status, :main_image)
  end
end