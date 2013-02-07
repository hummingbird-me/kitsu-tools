module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
    page_title.to_s
  end

  # For Devise
  def resource_name
    :user
  end
  def resource
    @resource ||= User.new
  end
  def resource_class
    User
  end
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
