module ApplicationHelper
  def is_current_user? user
    user == current_user
  end

  def user_avatar user
    user.avatar.url.nil? ? Settings.default_avatar : user.avatar.url
  end
end
