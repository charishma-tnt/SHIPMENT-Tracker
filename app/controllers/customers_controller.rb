# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer

  def index
    @customers = Customer.all
  end

  def show
    if current_user.customer.present?
      @shipments = current_user.customer.shipments.order(created_at: :desc)
    else
      @shipments = []
      flash[:alert] = "No customer profile found for this user."
    end
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: "Customer was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer data was uccessfully updated."
    else
      render :edit
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_url, notice: "Customer data was successfully destroyed."
  end

  private

  def set_customer
    @customer = current_user.customer
  end

  def customer_params
    params.require(:customer).permit(:name, :email)
  end

  def ensure_customer
    redirect_to root_path, alert: "Access denied." unless current_user.customer?
  end
end
