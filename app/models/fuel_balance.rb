class FuelBalance < ActiveRecord::Base
  belongs_to :depot_fuel, :foreign_key => "depot_fuel_id"
  belongs_to :fuel_tank, :foreign_key => "fuel_tank_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      FuelBalance.all 
    else
      curr_staff=Staff.find(staffid)
      FuelBalance.where(depot_fuel_id: DepotFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
end

# == Schema Information
#
# Table name: fuel_balances
#
#  created_at    :datetime
#  current       :decimal(, )
#  depot_fuel_id :integer
#  fuel_tank_id  :integer
#  id            :integer          not null, primary key
#  unit_type_id  :integer
#  updated_at    :datetime
#
