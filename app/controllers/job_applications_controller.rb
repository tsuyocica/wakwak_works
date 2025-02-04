class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_post, only: [:create, :destroy, :update_status]
  before_action :set_job_application_for_worker, only: [:destroy]
  before_action :set_job_application_for_manager, only: [:update_status]

  # 作業員の応募
  def create
    unless current_user.role == "作業員"
      redirect_to job_posts_path, alert: "作業員のみ応募できます。"
      return
    end

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

  # 応募の取り消し（作業員のみ）
  def destroy
    if @job_application
      @job_application.destroy
      redirect_to job_post_path(@job_post), notice: "応募をキャンセルしました。"
    else
      redirect_to job_post_path(@job_post), alert: "応募が見つかりません。"
    end
  end

  # 応募の状態を更新
  def update_status
    if params[:status].present? && %w[pending approved rejected].include?(params[:status])
      if @job_application.update(status: params[:status])
        render json: { success: true, status: @job_application.status }
      else
        render json: { success: false, errors: @job_application.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "無効なステータスです" }, status: :unprocessable_entity
    end
  end

  private

  def set_job_post
    @job_post = JobPost.find(params[:job_post_id])
  end

  def set_job_application_for_worker
    @job_application = @job_post.job_applications.find_by(worker: current_user)
  end

  def set_job_application_for_manager
    @job_application = @job_post.job_applications.find(params[:id])
  end
end