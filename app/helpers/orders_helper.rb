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

end
