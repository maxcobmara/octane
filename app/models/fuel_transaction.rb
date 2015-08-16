class FuelTransaction < ActiveRecord::Base
  belongs_to :fuel_unit_type, :class_name => "UnitType" , :foreign_key => "fuel_unit_type_id"
  belongs_to :fuel_type
  belongs_to :fuel_tank
  belongs_to :vehicle #usage only

  def self.by_type(transaction_type)
    where(transaction_type: transaction_type)
  end
  
end
