class Users::RegistrationsController < Devise::RegistrationsController

  # 更新後のリダイレクト先を変更（マイページへ）
  def after_update_path_for(resource)
    user_path(resource)
  end
end