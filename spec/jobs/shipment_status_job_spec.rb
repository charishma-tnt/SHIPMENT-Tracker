# require 'rails_helper'

# RSpec.describe ShipmentStatusJob, type: :job do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
# app/jobs/shipment_notification_job.rb
class ShipmentNotificationJob < ApplicationJob
  queue_as :default

  def perform(shipment)
    CustomerMailer.shipment_status_change(shipment).deliver_now
  end
end
