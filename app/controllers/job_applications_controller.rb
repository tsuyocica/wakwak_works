class JobApplicationsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_job_post, only: [:create, :destroy]
  before_action :set_job_application, only: [:destroy]

  # 作業員の応募
  def create
    # 作業員以外は応募不可
    unless current_user.role == "作業員"
      redirect_to job_posts_path, alert: "作業員のみ応募できます。"
      return
    end

    # すでに応募している場合のチェック
    if @job_post.job_applications.exists?(worker: current_user)
      redirect_to job_post_path(@job_post), alert: "すでに応募しています。"
      return
    end

    @job_application = @job_post.job_applications.new(worker: current_user, status: "pending")

    if @job_application.save
      redirect_to job_post_path(@job_post), notice: "応募が完了しました！"
    else
      redirect_to job_post_path(@job_post), alert: "応募に失敗しました。"
    end
  end

  # 応募の取り消し
  def destroy
    if @job_application
      @job_application.destroy
      redirect_to job_post_path(@job_post), notice: "応募をキャンセルしました。"
    else
      redirect_to job_post_path(@job_post), alert: "応募が見つかりません。"
    end
  end

  private

  # `@job_post` を取得
  def set_job_post
    @job_post = JobPost.find(params[:job_post_id])
  end

  # `@job_application` を取得
  def set_job_application
    @job_application = @job_post.job_applications.find_by(worker: current_user)
  end
end