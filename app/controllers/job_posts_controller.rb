class JobPostsController < ApplicationController

  def index
    @job_posts = JobPost.where(work_status: "recruiting").order(created_at: :desc) # 募集中の案件を表示
  end

    def show
      @job_post = JobPost.find(params[:id]) # URLのIDから案件を取得
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

  private

  def job_post_params
    params.require(:job_post).permit(:work_title, :work_description, :work_capacity, :work_start_date, :work_end_date, :work_payment, :work_location, :work_status)
  end
end
