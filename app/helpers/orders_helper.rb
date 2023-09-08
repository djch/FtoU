module OrdersHelper

  def status_color_class(status)
    case status
    when "pending"
      "text-amber-600"
    when "confirmed"
      "text-blue-600"
    when "cancelled"
      "text-red-600"
    when "delivered"
      "text-green-600"
    else
      "text-stone-800"
    end
  end

  def short_number_to_currency(amount, options = {})
    if amount && amount % 1 == 0  # Check if it's a whole number
      number_to_currency(amount, options.merge(precision: 0))
    else
      number_to_currency(amount, options)
    end
  end
end
