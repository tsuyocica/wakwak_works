class UsersController < ApplicationController
  before_action :authenticate_user! # ユーザーがログインしていない場合、ログインページへリダイレクト
  before_action :set_user, only: [:show, :edit, :update, :destroy, :show_manager, :show_worker]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # ユーザーのマイページ（施工管理者 or 作業員でリダイレクト）
  def show
    case @user.role
    when "施工管理者"
      redirect_to show_manager_user_path(@user)
    when "作業員"
      redirect_to show_worker_user_path(@user)
    else
      redirect_to root_path, alert: "不正なユーザー情報です。"
    end
  end

  # 施工管理者マイページ
  def show_manager
    @job_posts = @user.job_posts.order(created_at: :desc) # 施工管理者が投稿した案件を取得
  end

  # 作業員マイページ
  def show_worker
    # @job_applications = JobApplication.where(user: @user).includes(:job_post).order(created_at: :desc) # 作業員が応募した案件を取得
  end

  # ユーザー情報編集ページ
  def edit
  end

  # ユーザー情報更新
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "ユーザー情報を更新しました。"
    else
      flash.now[:alert] = "入力内容に誤りがあります"
      render :edit, status: :unprocessable_entity
    end
  end

  # ユーザー削除
  def destroy
    @user.destroy
    redirect_to root_path, notice: "アカウントを削除しました。"
  end

  private

  # ユーザー情報を取得
  def set_user
    @user = User.find(params[:id])
  end

  # 許可するパラメータ
  def user_params
    params.require(:user).permit(:username, :full_name, :furigana, :birth_date, :role, :experience, :qualification, :email, :password, :password_confirmation)
  end

  # ユーザー権限を確認（他人の編集・削除を防ぐ）
  def authorize_user
    redirect_to root_path, alert: "他のユーザーの情報は編集できません。" unless @user == current_user
  end
end