class IndenUsage < ActiveRecord::Base
  belongs_to :inden_card, foreign_key: "inden_card_id"
  belongs_to :unit_fuel, foreign_key: "unit_fuel_id"
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      IndenUsage.all 
    else
      curr_staff=Staff.find(staffid)
      IndenUsage.where(unit_fuel_id: UnitFuel.where(unit_id: curr_staff.unit_id).pluck(:id)) if curr_staff && curr_staff.unit_id
    end
  end
end

# == Schema Information
#
# Table name: inden_usages
#
#  created_at       :datetime
#  diesel_ltr       :decimal(, )
#  diesel_price     :decimal(, )
#  id               :integer          not null, primary key
#  inden_card_id    :integer
#  issue_date       :date
#  petrol_ltr       :decimal(, )
#  petrol_price     :decimal(, )
#  petronal_p_price :decimal(, )
#  petronas_d_ltr   :decimal(, )
#  petronas_d_price :decimal(, )
#  petronas_p_ltr   :decimal(, )
#  updated_at       :datetime
#
