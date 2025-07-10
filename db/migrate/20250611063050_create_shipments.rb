class CreateShipments < ActiveRecord::Migration[8.0]
  def change
    create_table :shipments do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :source
      t.string :target
      t.text :item_details
      t.string :status
      t.references :delivery_partner, null: false, foreign_key: { to_table: :delivery_partners }

      t.timestamps
    end
  end
end
