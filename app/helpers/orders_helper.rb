module OrdersHelper

  def status_color_class(status)
    case status
    when "pending"
      "bg-amber-600 text-white dark:bg-amber-400 dark:text-stone-800"
    when "confirmed"
      "bg-blue-600 text-white dark:bg-blue-400 dark:text-stone-800"
    when "cancelled"
      "bg-red-600 text-white dark:bg-red-400 dark:text-stone-800"
    when "delivered"
      "bg-green-600 text-white dark:bg-green-400 dark:text-stone-800"
    else
      "bg-stone-800 text-white"
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
