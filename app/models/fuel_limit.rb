class FuelLimit < ActiveRecord::Base
  belongs_to :unit
  belongs_to :limit_unit_type, :class_name => "UnitType", :foreign_key => "limit_unit_type_id"
  belongs_to :fuel_type
  belongs_to :fuel_unit_type, :class_name => "UnitType", :foreign_key => "fuel_unit_type_id"
  
  validates_presence_of :unit_id, :limit_amount, :limit_unit_type_id, :duration, :fuel_type_id, :fuel_unit_type_id
  validates_uniqueness_of :unit_id, :scope => :fuel_type_id, :message => " : already have Fuel Limit for selected Fuel type"
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      FuelLimit.all 
    else
      curr_staff=Staff.find(staffid)
      FuelLimit.where(unit_id: curr_staff.unit_id) if curr_staff && curr_staff.unit_id
    end
  end
  
  def details
    limit_amount.to_s+" "+limit_unit_type.short_name
  end
  
  def surpluses(budget_startdate, depot, fueltype)
    surplus_details=[]
    if budget_startdate.to_date.year==Date.today.year
      budget_end=Date.today 
    else
      budget_end=budget_startdate.to_date+364.days
    end
    limit_set=(budget_end-budget_startdate.to_date).to_i / (duration-1)
    1.upto(limit_set).each do |cnt|
      s1details=""
      s2details=""
      check_date=budget_startdate.to_date+(duration-1)*cnt
      if check_date <= budget_end
        before_date=check_date-(duration-1)
        usages=FuelIssued.joins(:depot_fuel).where('depot_fuels.unit_id=?', depot.id).where('depot_fuels.issue_date >=? and depot_fuels. issue_date <=?', before_date, check_date).where(fuel_type: FuelType.where(name: fueltype))
        usages2=FuelTransaction.where(transaction_type: 'Usage').where('created_at >=? and created_at <=?', before_date, check_date).where(fuel_tank_id: FuelTank.where(unit_id: depot.id).where(fuel_type: FuelType.where(name: fueltype)).pluck(:id))
        if usages
          surplus = usages.sum(:quantity)-limit_amount
          if surplus > 0 && usages.first.unit_type==limit_unit_type 
            s1details = check_date.strftime('%d %b')+": "+surplus.to_s+" "#+limit_unit_type.short_name#+"("+usages.sum(:quantity).to_s+")"
          end
        #end
        #if usages2
        else
          surplus2 = usages2.sum(:amount)-limit_amount
          if surplus2 > 0 && usages.first.unit_type==limit_unit_type 
            s2details =" / "+surplus2.to_s 
          end
        end
        surplus_details << s1details+s2details
      end
    end
    surplus_details #just 4 checking<< budget_startdate# << "limit set #{limit_set}"
  end
  
end
