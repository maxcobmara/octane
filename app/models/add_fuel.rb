class AddFuel < ActiveRecord::Base
  belongs_to :unit_fuel, :foreign_key => "unit_fuel_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  validates_presence_of :fuel_type_id, :quantity, :unit_type_id
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      AddFuel.all 
    else
      curr_staff=Staff.find(staffid)
      AddFuel.where(unit_fuel_id: UnitFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
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
