class AddColumnToIndenUsages < ActiveRecord::Migration
  def change
    add_column :inden_usages, :unit_fuel_id, :integer
  end
end
