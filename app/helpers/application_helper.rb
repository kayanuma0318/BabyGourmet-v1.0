module ApplicationHelper
  def flash_class(type)
    # 記述しない場合、格viewファイルでtypeに応じたクラスを毎回指定する必要があるので、この記述は必要である
    case type.to_sym
    when :success then "alert-success"
    when :danger then "alert-error"
    else "alert-info"
      # 予期せぬフラッシュメッセージの場合は、alert-infoを返す
    end
  end
end
