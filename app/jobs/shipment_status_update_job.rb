class ShipmentStatusUpdateJob < ApplicationJob
  queue_as :default

  def perform(shipment_id, new_status)
    shipment = Shipment.find_by(id: shipment_id)
    unless shipment
      Rails.logger.error("ShipmentStatusUpdateJob: Shipment with ID #{shipment_id} not found")
      return
    end

    begin
      shipment.update!(status: new_status)
      Rails.logger.info("ShipmentStatusUpdateJob: Updated shipment #{shipment_id} status to #{new_status}")
    rescue => e
      Rails.logger.error("ShipmentStatusUpdateJob: Failed to update shipment #{shipment_id} status - #{e.message}")
      raise e
    end
  end
end
