class AddColumnToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :fuel_type_id, :integer
    add_column :vehicles, :fuel_capacity, :decimal
    add_column :vehicles, :fuel_unit_type_id, :integer
    add_column :vehicles, :data, :text
    add_column :vehicles, :updated_by, :integer
    add_column :vehicles, :created_by, :integer
  end
end
