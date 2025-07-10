class ShipmentsController < ApplicationController
  before_action :authenticate_user!, except: [ :track ]
  before_action :set_shipment, only: [ :show, :edit, :update, :destroy, :accept_delivery ]

  def index
    if current_user.admin?
      @shipments = Shipment.all
    elsif current_user.customer? && current_user.customer.present?
      @shipments = Shipment.where(customer_id: current_user.customer.id)
    elsif current_user.delivery_partner?
      if current_user.delivery_partner.nil?
        del_part = DeliveryPartner.create!(
          name: current_user.email.split("@").first,
          email: current_user.email
        )
        current_user.update(delivery_partner: del_part)
      end
      @shipments = Shipment.where.not(delivery_partner_id: nil)
                           .where(delivery_partner_id: current_user.delivery_partner.id)
                           .where("status >= ?", Shipment::STATUS_VALUES["picked_up"])
      flash.now[:notice] = "Delivery partner present. Shipments count: #{@shipments.count}"
    else
      @shipments = []
    end

    # Calculate shipment stats for bar chart
    @total_shipments = @shipments.count
    @in_transit_count = @shipments.where(status: Shipment::STATUS_VALUES["in_transit"]).count
    @pending_count = @shipments.where(status: Shipment::STATUS_VALUES["pending"]).count
    @delivered_count = @shipments.where(status: Shipment::STATUS_VALUES["delivered"]).count
  end

  def dashboard
    if current_user.admin?
      @shipments = Shipment.all
      @total_customers = Customer.count
      @unassigned_shipments = Shipment.where(delivery_partner_id: nil)
      @delivery_partners = DeliveryPartner.all
    elsif current_user.customer? && current_user.customer.present?
      @shipments = Shipment.where(customer_id: current_user.customer.id)
      @delivered_shipments = Shipment.where(customer_id: current_user.customer.id, status: Shipment::STATUS_VALUES["delivered"])
    elsif current_user.delivery_partner? && current_user.delivery_partner.present?
      @shipments = Shipment.where(delivery_partner_id: current_user.delivery_partner.id)
    else
      @shipments = []
    end

    # Ensure @delivered_shipments is set to avoid nil error in view
    @delivered_shipments ||= Shipment.none

    # Ensure @shipments is an ActiveRecord::Relation for chaining
    @shipments = Shipment.where(id: @shipments.map(&:id)) if @shipments.is_a?(Array)

    # Calculate shipment stats
    @total_shipments = @shipments.count
    @in_transit_count = @shipments.where(status: Shipment::STATUS_VALUES["in_transit"]).count
    @pending_count = @shipments.where(status: Shipment::STATUS_VALUES["pending"]).count
    @delivered_count = @shipments.where(status: Shipment::STATUS_VALUES["delivered"]).count

    # Recent activity - last 5 shipments ordered by updated_at desc
    @recent_shipments = @shipments.order(updated_at: :desc).limit(5)
  end

  def show
  end

  def edit
    redirect_to shipment_path(@shipment), alert: "Editing shipments is not allowed."
  end

  def new
    # Allow admin to create shipments
    if current_user.admin?
      @shipment = Shipment.new
      @shipments = Shipment.all
    # Ensure current_user has a customer profile, or create one if missing
    elsif current_user.customer.present?
      @shipment = Shipment.new
      @shipments = Shipment.all
    elsif current_user.customer?
      # Auto-create customer profile if user is a customer but has no profile
      customer_profile = Customer.create(email: current_user.email, name: current_user.email.split("@").first)
      current_user.update(customer: customer_profile)
      @shipment = Shipment.new
      @shipments = Shipment.all
    else
      redirect_to root_path, alert: "Only customers can create shipments."
    end
  end

  def create
    if current_user.admin?
      @shipment = Shipment.new(shipment_params)
      if @shipment.save
        redirect_to @shipment, notice: "Shipment was successfully created."
      else
        render :new
      end
    elsif current_user.customer.present?
      @shipment = Shipment.new(shipment_params)
      @shipment.customer = current_user.customer

      if @shipment.save
        redirect_to @shipment, notice: "Shipment was successfully created."
      else
        render :new
      end
    elsif current_user.customer?
      # Auto-create customer profile if user is a customer but has no profile
      customer_profile = Customer.create(email: current_user.email, name: current_user.email.split("@").first)
      current_user.update(customer: customer_profile)
      @shipment = Shipment.new(shipment_params)
      @shipment.customer = current_user.customer

      if @shipment.save
        redirect_to @shipment, notice: "Shipment was successfully created."
      else
        render :new
      end
    else
      redirect_to root_path, alert: "Only customers can create shipments."
    end
  end

  def update
    @shipment = Shipment.find(params[:id])
    if current_user.admin?
      # Use background job to update shipment status asynchronously
      if shipment_params[:status].present?
        ShipmentStatusUpdateJob.perform_later(@shipment.id, shipment_params[:status])
        redirect_to request.referer || shipment_path(@shipment), notice: "Shipment status update is being processed."
      else
        if @shipment.update(shipment_params.except(:status))
          redirect_to request.referer || shipment_path(@shipment), notice: "Shipment was successfully updated."
        else
          render :edit
        end
      end
    elsif current_user.delivery_partner? && @shipment.delivery_partner_id == current_user.delivery_partner&.id
      # Allow delivery partner to update status only
      if params[:shipment][:status].present?
        @shipment.update(status: params[:shipment][:status])
      end
      redirect_to request.referer || shipment_path(@shipment), notice: "Shipment was successfully updated."
    else
      redirect_to root_path, alert: "You are not authorized to update this shipment."
    end
  end

  def destroy
    @shipment.destroy
    redirect_to shipments_url, notice: "Shipment was successfully deleted."
  end

  def track
    shipment_id = params[:tracking_id] || params[:id]
    @shipment = Shipment.find_by(id: shipment_id)

    if @shipment
      render :show
    else
      redirect_to root_path, alert: "No shipment found with that shipment ID"
    end
  end

  def accept_delivery
    if current_user.delivery_partner.present?
      @shipment.update(status: Shipment::STATUS_VALUES["in_transit"], delivery_partner: current_user.delivery_partner)
      redirect_to @shipment, notice: "Shipment status updated to 'In Transit'."
    else
      redirect_to shipments_path, alert: "You are not authorized to accept this shipment."
    end
  end

  def decline_delivery
    if current_user.delivery_partner? && @shipment.delivery_partner == current_user.delivery_partner
      @shipment.update(delivery_partner: nil, status: Shipment::STATUS_VALUES["pending"])
      redirect_to shipments_path, notice: "Shipment delivery declined and unassigned."
    else
      redirect_to shipments_path, alert: "You are not authorized to decline this shipment."
    end
  end

  private

  def set_shipment
    @shipment = Shipment.find(params[:id])
  end

  def shipment_params
    permitted = [ :source, :target, :item_details, :delivery_partner_id, :status ]
    permitted << :customer_id if current_user.admin?
    params.require(:shipment).permit(permitted)
  end
end
