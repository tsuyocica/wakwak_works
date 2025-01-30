class JobApplicationsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_job_post, only: [:create, :destroy]

  # 作業員の応募
  def create
    if current_user.role != "作業員"
      redirect_to job_posts_path, alert: "作業員のみ応募できます。"
      return
    end

    @job_application = @job_post.job_applications.new(worker: current_user)

    if @job_application.save
      redirect_to job_post_path(@job_post), notice: "応募が完了しました！"
    else
      redirect_to job_post_path(@job_post), alert: "応募に失敗しました。"
    end
  end

  # 応募の取り消し
  def destroy
    @job_application = @job_post.job_applications.find_by(worker: current_user)

    if @job_application
      @job_application.destroy
      redirect_to job_post_path(@job_post), notice: "応募をキャンセルしました。"
    else
      redirect_to job_post_path(@job_post), alert: "応募が見つかりません。"
    end
  end

  private

  def set_job_post
    @job_post = JobPost.find(params[:job_post_id])
  end
end