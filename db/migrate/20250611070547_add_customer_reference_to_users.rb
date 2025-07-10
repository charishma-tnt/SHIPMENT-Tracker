class AddCustomerReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :users, :customers, if_exists: true
    change_column_null :users, :customer_id, true
    add_foreign_key :users, :customers, null: true
  end
end
