require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WakwakWorks
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Stimulus コントローラーの読み込みパスを追加
    config.assets.paths << Rails.root.join("app/javascript/controllers")
    config.autoload_paths += Dir[Rails.root.join("app/javascript/controllers")
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # タイムゾーンを日本時間に設定
    config.time_zone = "Tokyo"

    # 日本語化ロケールの有効化
    config.i18n.default_locale = :ja

    # DBの時間も日本時間に設定
    config.active_record.default_timezone = :local

    # config/application.rb
    config.active_storage.variant_processor = :mini_magick
  end
end
