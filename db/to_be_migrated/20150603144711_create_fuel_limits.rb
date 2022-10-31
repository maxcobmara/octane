class CreateFuelLimits < ActiveRecord::Migration
  def change
    create_table :fuel_limits do |t|
      t.string :code
      t.integer :unit_id
      t.integer :limit_amount
      t.integer :limit_unit_type_id
      t.integer :duration
      t.integer :fuel_type_id
      t.integer :fuel_unit_type_id
      t.text :emails
      t.text :data

      t.timestamps null: false
    end
  end
end
