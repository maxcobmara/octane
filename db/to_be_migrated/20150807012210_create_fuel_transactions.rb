class CreateFuelTransactions < ActiveRecord::Migration
  def change
    create_table :fuel_transactions do |t|
      t.string  :document_code
      t.string  :transaction_type
      t.decimal :amount
      t.integer :fuel_type_id
      t.integer :fuel_unit_type_id
      t.integer :fuel_tank_id
      t.integer :vehicle_id
      t.text :data

      t.integer :created_by
      t.integer :updated_by
      t.timestamps null: false
    end
  end
end
