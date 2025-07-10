class AddDeliveryPartnerReferenceToUsers < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :users, :delivery_partners, if_exists: true
    change_column_null :users, :delivery_partner_id, true
    add_foreign_key :users, :delivery_partners, null: true
  end
end
