class ChangeStatusToIntegerInShipments < ActiveRecord::Migration[8.0]
  def up
    change_column :shipments, :status, :integer, default: 0
  end

  def down
    change_column :shipments, :status, :string
  end
end
