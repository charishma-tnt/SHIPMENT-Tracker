class ChangeStatusToIntegerInShipments < ActiveRecord::Migration[8.0]
  def up
    # Add a temporary column
    add_column :shipments, :status_int, :integer, default: 0

    # Update the temporary column based on string values
    execute <<-SQL
      UPDATE shipments#{' '}
      SET status_int = CASE status
        WHEN 'pending' THEN 0
        WHEN 'in_transit' THEN 1
        WHEN 'delivered' THEN 2
        WHEN 'cancelled' THEN 3
        ELSE 0
      END;
    SQL

    # Remove the old status column
    remove_column :shipments, :status

    # Rename the new column to status
    rename_column :shipments, :status_int, :status
  end

  def down
    change_column :shipments, :status, :string
  end
end
