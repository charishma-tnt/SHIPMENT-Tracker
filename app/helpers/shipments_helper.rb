module ShipmentsHelper
  def status_color(status)
    case status
    when "pending"
      "bg-yellow-100 text-yellow-800"
    when "in_transit"
      "bg-blue-100 text-blue-800"
    when "delivered"
      "bg-green-100 text-green-800"
    when "cancelled"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def progress_width(status)
    case status
    when "pending"
      "w-1/4"
    when "in_transit"
      "w-2/4"
    when "out_for_delivery"
      "w-3/4"
    when "delivered"
      "w-full"
    else
      "w-0"
    end
  end
end
