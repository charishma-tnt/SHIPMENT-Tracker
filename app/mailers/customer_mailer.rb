class CustomerMailer < ApplicationMailer
  def shipment_status_change(shipment)
    @shipment = shipment
    mail(to: @shipment.customer.email, subject: "Shipment Status Update")
  end
end
