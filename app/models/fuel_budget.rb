class FuelBudget < ActiveRecord::Base
  belongs_to :unit
  belongs_to :fuel_type
  belongs_to :unit_type
  
  validates_presence_of :unit_id, :fuel_type_id, :unit_type_id, :amount
  
  scope :petrol, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'PETROL')) }
  scope :diesel, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'DIESEL')) }
  scope :avtur, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'AVTUR')) }
  scope :avcat, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'AVCAT')) }
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      FuelBudget.all 
    else
      curr_staff=Staff.find(staffid)
      FuelBudget.where(unit_id: curr_staff.unit_id) if curr_staff && curr_staff.unit_id
    end
  end
  
  #report: budget vs usage listing
  def self.usages(usage_recs)
    ssub_fuel_usage=[]
    usage_recs.group_by{|x|x.fuel_tank.unit}.each do |depot, fuelusages|
      fuel_usages_vehicles=usage_recs.where(id: fuelusages.map(&:id)).where(is_vehicle: true)
      fuel_vehicle_ids=fuel_usages_vehicles.pluck(:vehicle_id).compact.uniq
      sub_fuel_usage=[]
      VehicleAssignment.all.each do |vas|   
        vehicles_own= vas.vehicle_assignment_details.pluck(:vehicle_id)
        usages_own=fuel_usages_vehicles.where(vehicle_id: vehicles_own)
        sub_fuel_usage << [vas.unit_receiver, usages_own.sum(:amount)] if (vehicles_own & fuel_vehicle_ids !=[]) && fuel_vehicle_ids.count > 0
      end
      usage_recs.where(id: fuelusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        sub_diesel_usage << [unit_vessel, usage.sum(&:amount)]
      end
      ssub_fuel_usage << [depot, sub_fuel_usage]
    end
    ssub_fuel_usage
  end
  
  #report: budget vs usage-retrieve ALL Diesel & Petrol usage (within selected budget year) for each unit
  def self.unit_usage(unit_fuels, budget, fuelname, start_from, end_on)
    fuel_usage=Hash.new
    unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=budget.where(fuel_type: (FuelType.where(name: fuelname))).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', budget_startdate, budget_enddate)
        else
          #retrieve all usage within selected year if budget not exist
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', start_from, end_on)
        end
        if fuelname=='DIESEL'
          fuel_usage[unit.name]=unitfuels2.sum(:d_vessel)+unitfuels2.sum(:d_vehicle)+unitfuels2.sum(:d_misctool)+unitfuels2.sum(:d_boat) 
        elsif fuelname=='PETROL'
          fuel_usage[unit.name]=unitfuels2.sum(:p_vehicle)+unitfuels2.sum(:p_misctool)+unitfuels2.sum(:p_boat) 
        end
    end
    fuel_usage
  end
  
  #report: budget vs usage-retrieve ALL AVTUR & AVCAT usage (within selected budget year) for each unit
  def self.unit_usage2(unit_fuels, budget, fuelname, start_from, end_on)
    fuel_usage=Hash.new
    unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=budget.where(fuel_type_id: (FuelType.where(name: fuelname)).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          fuel_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: fuelname)).first.id).where(unit_id:   unit.id).where('issue_date >=? and issue_date<=?', budget_startdate, budget_enddate).sum(:quantity)
        else
          fuel_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: fuelname)).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', start_from, end_on).sum(:quantity)
        end
    end
    fuel_usage
  end
  
end
