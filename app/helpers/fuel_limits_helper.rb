module FuelLimitsHelper
  #Below - used for REAL TIME notification, whereas those in Fuel Limit used for DISPLAY purpose for all notification throughout the budget year
  def diesel_limit(unitid)
    FuelLimit.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id).first
  end
  
  def petrol_limit(unitid)
    FuelLimit.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id).first
  end
  
  def avtur_limit(unitid)
    FuelLimit.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id).first
  end
  
  def avcat_limit(unitid)
    FuelLimit.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id).first
  end
end
