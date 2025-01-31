class UsersController < ApplicationController
  before_action :authenticate_user! # ユーザーがログインしていない場合、ログインページへリダイレクト
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # ユーザーマイページ
  def show
    if @user.role == "施工管理者"
      @job_posts = @user.job_posts.order(created_at: :desc) # 施工管理者の投稿案件
    else
      @job_applications = JobApplication.where(worker_id: @user.id).includes(:job_post).order(created_at: :desc) # 作業員の応募案件
    end
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

  def switch_role
    new_role = current_user.role == "施工管理者" ? "作業員" : "施工管理者"
    if current_user.update(role: new_role)
      redirect_to request.referer || root_path, notice: "#{new_role}に切り替えました。"
    else
      redirect_to request.referer || root_path, alert: "役割の変更に失敗しました。"
    end
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