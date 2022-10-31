class AddColumnToFuelIssueds < ActiveRecord::Migration
  def change
    add_column :fuel_issueds, :unit_id, :integer
  end
end
