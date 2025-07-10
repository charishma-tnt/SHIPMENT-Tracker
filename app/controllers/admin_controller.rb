class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def show
    @customers = User.where(role: :customer)
    @delivery_partners = User.where(role: :delivery_partner)
    @shipments = Shipment.all
    @pending_shipments = Shipment.where(status: :pending)
  end

  def assign_shipment
    shipment = Shipment.find(params[:shipment_id])
    delivery_partner = User.find(params[:delivery_partner_id])

    if shipment && delivery_partner && delivery_partner.delivery_partner?
      shipment.delivery_partner = delivery_partner
      shipment.status = Shipment::STATUS_VALUES["in_transit"]
      if shipment.save
        redirect_to admin_path, notice: "Shipment ##{shipment.id} assigned to #{delivery_partner.email}."
      else
        redirect_to admin_path, alert: "Failed to assign shipment."
      end
    else
      redirect_to admin_path, alert: "Invalid shipment or delivery partner."
    end
  end

  private

  def authorize_admin
    allowed_admin_emails = [ "lucky@2004@gmail.com", "admin123@gmail.com" ]
    unless current_user.admin? && allowed_admin_emails.include?(current_user.email)
      sign_out current_user
      redirect_to new_user_session_path, alert: "You are not authorized to access this page."
    end
  end
end
