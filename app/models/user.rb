class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :delivery_partner, optional: true
  belongs_to :customer, optional: true
  after_create :ensure_associations

  # Fix enum syntax for Rails 8.0
  enum :role, {
    customer: 0,
    delivery_partner: 1,
    admin: 2
  }, default: :customer

  validates :role, presence: true

  def admin?
    role == "admin"
  end

  def customer?
    role == "customer"
  end

  def delivery_partner?
    role == "delivery_partner"
  end

  private

  def ensure_associations
    if customer? && customer.nil?
      cust = Customer.create!(
        name: email.split("@").first,
        email: email
      )
      self.customer = cust
    elsif delivery_partner? && delivery_partner.nil?
      del_part = DeliveryPartner.create!(
        name: email.split("@").first,
        email: email
      )
      self.delivery_partner = del_part
    end
  end
end
