class Customer < ApplicationRecord
  has_one :user
  has_many :shipments

  validates :email, presence: true
  validates :name, presence: true
end
