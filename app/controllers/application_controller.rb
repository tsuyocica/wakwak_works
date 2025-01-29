class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    added_keys = [:username, :full_name, :furigana, :birth_date, :experience]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: added_keys)
  end
end