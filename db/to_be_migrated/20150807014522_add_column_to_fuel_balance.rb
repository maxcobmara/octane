class AddColumnToFuelBalance < ActiveRecord::Migration
  def change
    add_column :fuel_balances, :usage_transactions, :integer
    add_column :fuel_balances, :usage_amount,       :decimal
    add_column :fuel_balances, :resupply_transactions,  :integer
    add_column :fuel_balances, :resupply_amount,        :decimal
    add_column :fuel_balances, :data, :text
  end
end
