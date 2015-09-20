class FuelIssued < ActiveRecord::Base
  before_save :default_unit_type_if_nil
  belongs_to :depot_fuel, :foreign_key => "depot_fuel_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  belongs_to :receiver, :class_name => "Unit", :foreign_key => "unit_id"
  
  def default_unit_type_if_nil
    if unit_type_id.blank?
      self.unit_type_id=UnitType.where(description: 'LITRE').first.id
    end
  end
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      FuelIssued.all 
    else
      curr_staff=Staff.find(staffid)
      FuelIssued.where(depot_fuel_id: DepotFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
end

# == Schema Information
#
# Table name: fuel_issueds
#
#  created_at    :datetime
#  depot_fuel_id :integer
#  fuel_type_id  :integer
#  id            :integer          not null, primary key
#  quantity      :decimal(, )
#  unit_type_id  :integer
#  updated_at    :datetime
#
