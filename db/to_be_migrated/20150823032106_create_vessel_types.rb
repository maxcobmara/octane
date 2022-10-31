class CreateVesselTypes < ActiveRecord::Migration
  def change
    create_table :vessel_types do |t|
      t.string :short_name
      t.string :description
      
      t.timestamps null: false
    end
  end
end
