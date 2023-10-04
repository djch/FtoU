module DeliveriesHelper
  def display_dots_for_date(date, deliveries_count_by_date)
    count = deliveries_count_by_date[date] || 0

    case count
    when 0
      "&nbsp;".html_safe
    when 1..4
      content_tag(:span, "•")
    when 5..8
      content_tag(:span, "•") + content_tag(:span, "•")
    when 9..12
      content_tag(:span, "•") * 3
    else
      content_tag(:span, "•") * 4
    end
  end
end
