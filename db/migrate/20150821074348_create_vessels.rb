class CreateVessels < ActiveRecord::Migration
  def change
    create_table :vessels do |t|
      t.string :pennent_no
      t.integer :vessel_category_id
      t.integer :unit_id
      
      t.timestamps null: false
    end
  end
end
