require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BabyGourmetV10
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #

    #timezoneの設定
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # i18nの設定
    config.i18n.default_locale = :ja

    # rails gコマンドで生成されるファイルを制御する
    config.generators.system_tests = nil
    config.generators do |g|
      g.skip_routes true
      # ルーティングの記述をスキップ
      g.helper false
      # ヘルパーファイルの生成をスキップ
      g.test_framework nil
      # テストファイルの生成をスキップ
    end
  end
end
