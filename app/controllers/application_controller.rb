class ApplicationController < ActionController::Base
  add_flash_types :success, :danger
  # フラッシュメッセージのkeyを追加（デフォルト: notice, alert）
end
