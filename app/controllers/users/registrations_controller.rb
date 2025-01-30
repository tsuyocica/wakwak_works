class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  protected

  # アカウント更新時のストロングパラメータを設定
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :full_name, :furigana, :birth_date, :role, :experience, :qualification, :email, :password, :password_confirmation, :current_password
    ])
  end

  # Deviseのupdateをカスタマイズ（パスワード未入力なら変更なし）
  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    resource.update_with_password(params)
  end

  # 更新後のリダイレクト先を変更（マイページへ）
  def after_update_path_for(resource)
    user_path(resource)
  end
end