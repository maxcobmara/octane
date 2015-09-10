class FuelSupplied < ActiveRecord::Base
  belongs_to :depot_fuel, :foreign_key => "depot_fuel_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      FuelSupplied.all 
    else
      curr_staff=Staff.find(staffid)
      FuelSupplied.where(depot_fuel_id: DepotFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
end

# == Schema Information
#
# Table name: fuel_supplieds
#
#  created_at    :datetime
#  depot_fuel_id :integer
#  fuel_type_id  :integer
#  id            :integer          not null, primary key
#  quantity      :decimal(, )
#  unit_type_id  :integer
#  updated_at    :datetime
#
