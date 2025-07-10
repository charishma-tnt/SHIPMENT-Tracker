class MakeCustomerIdNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :customer_id, true
  end
end
