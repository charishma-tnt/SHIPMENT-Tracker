class CreateDeliveryPartners < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_partners do |t| # s
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
