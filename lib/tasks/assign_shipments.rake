namespace :shipments do
  desc "Assign multiple shipments to a delivery partner user"
  task :assign, [ :user_id, :shipment_ids ] => :environment do |t, args|
    user_id = args[:user_id]
    shipment_ids = args[:shipment_ids]

    if user_id.nil? || shipment_ids.nil?
      puts "Usage: rake shipments:assign[user_id,shipment_ids_comma_separated]"
      exit 1
    end

    user = User.find_by(id: user_id)
    unless user
      puts "User with ID #{user_id} not found."
      exit 1
    end

    shipment_ids_array = shipment_ids.split(",").map(&:strip)
    shipment_ids_array.each do |shipment_id|
      shipment = Shipment.find_by(id: shipment_id)
      if shipment
        shipment.update(delivery_partner_id: user.delivery_partner_id)
        puts "Assigned shipment ##{shipment_id} to user ##{user_id}."
      else
        puts "Shipment with ID #{shipment_id} not found."
      end
    end
  end
end
