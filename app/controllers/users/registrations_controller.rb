class Users::RegistrationsController < Devise::RegistrationsController

  # 更新後のリダイレクト先を変更（マイページへ）
  def after_update_path_for(resource)
    user_path(resource)
  end

  # ✅ ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    job_posts_path
  end
end