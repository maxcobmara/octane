class AddFuel < ActiveRecord::Base
  belongs_to :unit_fuel, :foreign_key => "unit_fuel_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
end

# == Schema Information
#
# Table name: add_fuels
#
#  created_at   :datetime
#  description  :string(255)
#  fuel_type_id :integer
#  id           :integer          not null, primary key
#  quantity     :decimal(, )
#  unit_fuel_id :integer
#  unit_type_id :integer
#  updated_at   :datetime
#
