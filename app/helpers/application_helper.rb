module ApplicationHelper
  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def time_ago_in_words(from_time)
    return "" unless from_time

    distance = Time.current - from_time
    case distance
    when 0..59
      "#{distance.to_i} seconds"
    when 60..3599
      "#{(distance / 60).to_i} minutes"
    when 3600..86399
      "#{(distance / 3600).to_i} hours"
    when 86400..2591999
      "#{(distance / 86400).to_i} days"
    else
      from_time.strftime("%B %d, %Y")
    end
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
