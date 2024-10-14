class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :info
  # フラッシュメッセージのkeyを追加（デフォルト: notice, alert）

  private
  # タブのパラメータを付与してリダイレクトするメソッド
  def redirect_to_with_tab(path, options = {})
    tab = params[:tab]
    if tab
      redirect_to(path, options.merge(tab: tab))
    else
      redirect_to(path, options)
    end
  end
  # 1. タブのパラメータが存在するかをチェック
  # 2. 存在する場合は、リダイレクト先のパスにタブのパラメータをmergeさせる
  # 3. 存在しない場合は、リダイレクト先のパスのままリダイレクトさせる
end
