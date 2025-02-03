class JobApplicationsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_job_post, only: [:create, :destroy, :update_status]
  before_action :set_job_application_for_worker, only: [:destroy]
  before_action :set_job_application_for_manager, only: [:approve, :reject, :update_status] # update_status に適用

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

  # 応募の取り消し（作業員のみ）
  def destroy
    if @job_application
      @job_application.destroy
      redirect_to job_post_path(@job_post), notice: "応募をキャンセルしました。"
    else
      redirect_to job_post_path(@job_post), alert: "応募が見つかりません。"
    end
  end

  # 応募を承認（施工管理者のみ）
  def approve
    if @job_application.update(status: "approved")
      render json: { success: true, status: "approved" }, status: :ok
    else
      render json: { success: false, errors: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 応募を却下（施工管理者のみ）
  def reject
    if @job_application.update(status: "rejected")
      render json: { success: true, status: "rejected" }, status: :ok
    else
      render json: { success: false, errors: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 応募の状態を更新（非同期）
  def update_status
    if params[:status].present? && %w[pending approved rejected].include?(params[:status])
      if @job_application.update(status: params[:status])
        render json: { success: true, status: @job_application.status }, status: :ok
      else
        render json: { success: false, errors: @job_application.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "無効なステータスです" }, status: :unprocessable_entity
    end
  end

  private

  # `@job_post` を取得（`create` / `destroy` / `update_status` 用）
  def set_job_post
    @job_post = JobPost.find(params[:job_post_id])
  end

  # `@job_application` を取得（作業員が自身の応募を削除）
  def set_job_application_for_worker
    @job_application = @job_post.job_applications.find_by(worker: current_user)
  end

  # `@job_application` を取得（施工管理者が承認 / 却下 / ステータス更新）
  def set_job_application_for_manager
    @job_application = JobApplication.find(params[:id])
  end
end