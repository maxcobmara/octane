class CreateFuelBudgets < ActiveRecord::Migration
  def change
    create_table :fuel_budgets do |t|
      t.integer :parent_id
      t.string :code
      t.integer :unit_id
      t.datetime :year_starts_on
      t.integer :fuel_type_id
      t.integer :amount
      t.integer :unit_type_id

      t.timestamps null: false
    end
  end
end
