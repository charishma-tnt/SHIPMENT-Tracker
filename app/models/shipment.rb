class Shipment < ApplicationRecord
  belongs_to :customer
  belongs_to :delivery_partner, optional: true

  # Remove enum and use a plain integer column for status
  STATUS_VALUES = {
    "pending" => 0,
    "picked_up" => 1,
    "in_transit" => 2,
    "delivered" => 3
  }

  def status_name
    STATUS_VALUES.key(self.status) || "unknown"
  end

  def status_humanize
    status_name.to_s.humanize
  end

  validates :source, presence: true
  validates :target, presence: true
  validates :item_details, presence: true

  broadcasts_to ->(shipment) { "shipments" }

  after_create_commit do
    broadcast_prepend_to "shipments", partial: "shipments/shipment", locals: { shipment: self }, target: "shipments"
  end

  after_update_commit do
    broadcast_replace_to "shipments", partial: "shipments/shipment", locals: { shipment: self }
  end

  after_destroy_commit do
    broadcast_remove_to "shipments", target: "shipment_#{id}"
  end

  after_update_commit :notify_customer

  private

  def notify_customer
    ShipmentStatusJob.perform_later(self.id)
  end
end
