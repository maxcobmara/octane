module FuelBudgetsHelper
  #Below - used for REAL TIME notification, whereas those in Fuel Limit used for DISPLAY purpose for all notification throughout the budget year
  def diesel_budgets(unitid)
    FuelBudget.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id)
  end
  
  def petrol_budgets(unitid)
    FuelBudget.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id)
  end
  
  def avtur_budgets(unitid)
    FuelBudget.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id)
  end
  
  def avcat_budgets(unitid)
    FuelBudget.where(unit_id: unitid).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id)
  end
end
