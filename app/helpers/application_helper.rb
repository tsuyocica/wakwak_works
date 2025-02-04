module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :notice then "success"
    when :alert then "danger"
    when :error then "danger"
    when :warning then "warning"
    else "info"
    end
  end
end
