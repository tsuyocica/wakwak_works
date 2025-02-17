class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :basic_auth

  # ✅ ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    job_posts_path
  end

  private

  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    added_keys = [:avatar, :username, :full_name, :furigana, :birth_date, :role, :experience, :qualification]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: added_keys + [:email, :password, :password_confirmation, :current_password])
  end

  # 環境変数をRailsアプリケーション側で読み込む設定
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]  # 環境変数を読み込む記述に変更
    end
  end
end