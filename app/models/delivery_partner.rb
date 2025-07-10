# app/models/delivery_partner.rb
class DeliveryPartner < ApplicationRecord
  has_one :user
  has_many :shipments

  validates :email, presence: true
  validates :name, presence: true

  after_create_commit { broadcast_prepend_to "delivery_partners", partial: "delivery_partners/delivery_partner", locals: { delivery_partner: self }, target: "delivery_partners" }
  after_update_commit { broadcast_replace_to "delivery_partners", partial: "delivery_partners/delivery_partner", locals: { delivery_partner: self } }
  after_destroy_commit { broadcast_remove_to "delivery_partners", target: "delivery_partner_#{id}" }
end
