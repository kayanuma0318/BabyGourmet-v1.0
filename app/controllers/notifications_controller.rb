class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 全てのyummy通知を既読にするアクション
  def mark_yummy_as_read
    current_user.notifications.where(action_type: 'yummy').unread.update_all(read_at: Time.current)
    redirect_to_with_tab(my_page_path(current_user, tab: 'yummy', yummy_page: params[:yummy_page]), success: '全てのyummy通知を既読にしました')
  end

  # 全てのcomment通知を既読にするアクション
  def mark_comment_as_read
    current_user.notifications.where(action_type: 'comment').unread.update_all(read_at: Time.current)
    redirect_to_with_tab(my_page_path(current_user, tab: 'comment', comment_page: params[:comment_page]), success: '全てのcomment通知を既読にしました')
  end

  # 全てのyummy通知を削除アクション
  def delete_all_yummy
    current_user.notifications.where(action_type: 'yummy').destroy_all
    redirect_to_with_tab(my_page_path(current_user, tab: 'yummy', yummy_page: params[:yummy_page]), danger: '全てのyummy通知を削除しました')
  end

  # 全てのcomment通知を削除アクション
  def delete_all_comment
    current_user.notifications.where(action_type: 'comment').destroy_all
    redirect_to_with_tab(my_page_path(current_user, tab: 'comment', comment_page: params[:comment_page]), danger: '全てのcomment通知を削除しました')
  end
end
