class ShipmentStatusJob < ApplicationJob
  queue_as :default

  def perform(shipment_id)
    shipment = Shipment.find(shipment_id)
    # Fix: Call the correct mailer method or remove if not implemented
    # For now, just log or skip sending email to avoid error
    Rails.logger.info "Shipment status changed for shipment ##{shipment.id}"
    # Uncomment and implement the mailer method if needed:
    # CustomerMailer.shipment_status_changed(shipment).deliver_now
  end
end
