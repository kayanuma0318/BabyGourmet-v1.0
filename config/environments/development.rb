require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # メール送信のエラーを表示しない
  config.action_mailer.raise_delivery_errors = false

  # メール送信のキャッシュを無効にする
  config.action_mailer.perform_caching = false

  # メール送信の設定
  # デフォルトのURL設定：開発環境ではlocalhostのポート3000を使用
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # メール送信方法をSMTP（Simple Mail Transfer Protocol）に設定
  config.action_mailer.delivery_method = :smtp

  # SMTP設定の詳細
  config.action_mailer.smtp_settings = {
    # Gmailのサーバーアドレスを指定
    address: 'smtp.gmail.com',
    # SMTPサーバーのポート番号（Gmail標準のポート）
    port: 587,
    # メールを送信するドメイン（開発環境ではlocalhostを使用）
    domain: 'localhost',
    # メール送信に使用するGmailアカウントのアドレス（環境変数から取得）
    user_name: ENV['MAILER_SENDER'],
    # Gmailアカウントのパスワードまたはアプリパスワード（環境変数から取得）
    password: ENV['MAILER_PASSWORD'],
    # 認証方式を指定（plain：平文認証）
    authentication: 'plain',
    # STARTTLS（Transport Layer Security）を有効化
    # これにより、平文での通信を暗号化された通信にアップグレード
    enable_starttls_auto: true
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end
