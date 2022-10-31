class AddColumnToFuelTransactions < ActiveRecord::Migration
  def change
    add_column :fuel_transactions, :vessel_id, :integer
    add_column :fuel_transactions, :is_vehicle, :boolean
  end
end
