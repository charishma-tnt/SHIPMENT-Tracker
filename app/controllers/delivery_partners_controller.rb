class DeliveryPartnersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_delivery_partner
  before_action :set_delivery_partner, only: [ :show ]

  def show
    if current_user.delivery_partner.present? && @delivery_partner == current_user.delivery_partner
      @shipments = Shipment.where(delivery_partner_id: current_user.delivery_partner.id)
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  private

  def set_delivery_partner
    @delivery_partner = DeliveryPartner.find(params[:id])
  end

  def ensure_delivery_partner
    redirect_to root_path, alert: "Access denied." unless current_user.delivery_partner?
  end
end
