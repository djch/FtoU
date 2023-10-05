module DeliveriesHelper
  def display_dots_for_date(date, deliveries_count_by_date)
    count = deliveries_count_by_date[date] || 0
    return "&nbsp;".html_safe if count.zero?

    number_of_dots = [count, 14].min

    dots = (1..number_of_dots).map do
      content_tag(:span, "•", class: "h-[0.25rem]") * 3
    end

    dots.join.html_safe
  end
end
