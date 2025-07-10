# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Example customer
customer = User.create(email: "customer@example.com", password: "password", role: "customer")
#
# # Example delivery partner
delivery_partner = User.create(email: "delivery_partner@example.com", password: "password", role: "delivery_partner")
#
# # Example admin
User.create(email: "charishmak@gmail.com", password: "20042020", role: "admin")

# # Example shipment
Shipment.create(
  source: "New York",
  target: "Los Angeles",
  item_details: "Electronics",
  customer: customer.customer,
  delivery_partner: delivery_partner.delivery_partner,
  status: "pending"
)
