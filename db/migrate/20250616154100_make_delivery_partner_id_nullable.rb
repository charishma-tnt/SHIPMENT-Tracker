class MakeDeliveryPartnerIdNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :delivery_partner_id, true
  end
end
