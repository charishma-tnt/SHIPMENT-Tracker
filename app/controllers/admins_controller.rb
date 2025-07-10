class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def show
    # Admin dashboard or overview page
    @delivery_partners = DeliveryPartner.all
    @pending_shipments = Shipment.where(delivery_partner_id: nil)
    @updated_shipments = Shipment.where.not(delivery_partner_id: nil)
  end

  def destroy_shipment
    shipment = Shipment.find(params[:id])
    shipment.destroy
    redirect_to admin_path, notice: "Shipment ##{shipment.id} was successfully deleted."
  end

  def assign_shipment
    shipment = Shipment.find(params[:shipment_id])
    delivery_partner = DeliveryPartner.find(params[:delivery_partner_id])

    shipment.update(delivery_partner: delivery_partner)

    # Update the User record associated with this delivery partner to keep association in sync
    user = User.find_by(delivery_partner_id: delivery_partner.id)
    if user.present? && user.delivery_partner != delivery_partner
      user.update(delivery_partner: delivery_partner)
    end

    redirect_to admin_path, notice: "Shipment ##{shipment.id} assigned to delivery partner #{delivery_partner.name}."
  end

  private

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
