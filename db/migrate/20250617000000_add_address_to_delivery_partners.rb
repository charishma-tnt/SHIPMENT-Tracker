class AddAddressToDeliveryPartners < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_partners, :address, :string
  end
end
