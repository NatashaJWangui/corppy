module ApplicationHelper
  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def flash_class(type)
    case type.to_sym
    when :notice
      "bg-green-50 border border-green-200 text-green-800"
    when :alert, :error
      "bg-red-50 border border-red-200 text-red-800"
    when :warning
      "bg-yellow-50 border border-yellow-200 text-yellow-800"
    else
      "bg-blue-50 border border-blue-200 text-blue-800"
    end
  end

  def page_title(title = nil)
    if title.present?
      "#{title} | Corppy"
    else
      "Corppy - Business Registration Made Simple"
    end
  end
end
