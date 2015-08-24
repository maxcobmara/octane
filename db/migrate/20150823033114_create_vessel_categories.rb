class CreateVesselCategories < ActiveRecord::Migration
  def change
    create_table :vessel_categories do |t|
      t.string :short_name
      t.string :description
      t.integer :vessel_type_id
      
      t.timestamps null: false
    end
  end
end
