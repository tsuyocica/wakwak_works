class JobPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index] # ログイン必須
  before_action :set_job_post, only: [:show, :edit, :update, :destroy]

  def index
    @job_posts = JobPost.where(work_status: "recruiting").order(created_at: :desc) # 募集中の案件を表示
  end

  def show
  end

  def new
    @job_post = JobPost.new
  end

  def create
    @job_post = current_user.job_posts.build(job_post_params) # ログインユーザーの投稿として作成
    if @job_post.save
      redirect_to @job_post, notice: "案件を作成しました！"
    else
      flash.now[:alert] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @job_post が nil の場合のエラーハンドリング（念のため）
    unless @job_post
      redirect_to job_posts_path, alert: "案件が見つかりませんでした。"
    end
  end

  def update
    if @job_post.update(job_post_params)
      redirect_to @job_post, notice: "案件を更新しました！"
    else
      flash.now[:alert] = "入力内容に誤りがあります"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_post.destroy
    redirect_to job_posts_path, notice: "案件を削除しました。"
  end

  private

  def set_job_post
    @job_post = JobPost.find_by(id: params[:id]) # `find_by` を使用してエラーを防ぐ
    unless @job_post
      redirect_to job_posts_path, alert: "該当する案件が見つかりません。"
    end
  end

  def job_post_params
    params.require(:job_post).permit(:work_title, :work_description, :work_capacity, :work_start_date, :work_end_date, :work_payment, :work_location, :work_status)
  end
end