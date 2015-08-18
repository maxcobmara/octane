class FuelTransaction < ActiveRecord::Base
  belongs_to :fuel_unit_type, :class_name => "UnitType" , :foreign_key => "fuel_unit_type_id"
  belongs_to :fuel_type
  belongs_to :fuel_tank
  belongs_to :vehicle
  validates_presence_of :amount
  validate :fuel_type_must_match

  def self.by_type(transaction_type)
    where(transaction_type: transaction_type)
  end
  
  def fuel_type_must_match
    if fuel_type_id != fuel_tank.fuel_type_id
      errors.add(:fuel_type_id, " must match with fuel type of Fuel Tank")
    end
  end
  
end
