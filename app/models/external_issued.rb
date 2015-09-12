class ExternalIssued < ActiveRecord::Base
  belongs_to :resource, :class_name => "Unit", :foreign_key => "source"
  belongs_to :unit_fuel, :foreign_key => "unit_fuel_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      ExternalIssued.all 
    else
      curr_staff=Staff.find(staffid)
      ExternalIssued.where(unit_fuel_id: UnitFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
end

# == Schema Information
#
# Table name: external_issueds
#
#  created_at   :datetime
#  fuel_type_id :integer
#  id           :integer          not null, primary key
#  quantity     :decimal(, )
#  source       :integer
#  unit_fuel_id :integer
#  unit_type_id :integer
#  updated_at   :datetime
#
