class FuelTank < ActiveRecord::Base
  belongs_to :unit,   :class_name => "Unit",   :foreign_key => "unit_id"
  belongs_to :unittype,   :class_name => "UnitType",   :foreign_key => "unit_type"
  belongs_to :fuel_type,   :class_name => "FuelType",   :foreign_key => "fuel_type_id"
  has_many :fuel_balances, dependent: :destroy
  has_many :fuel_transactions
  
  def fuel_tank_type
    "#{locations}"+" - #{fuel_type.name}"
  end
  
  def fuel_tank_details
    "#{unit.name}"+" | "+fuel_tank_type
  end
  
	
  def self.get_tank(tank_name, depot_id, fuel_type_id, capacity)
    tankno = tank_name.split(" ")[tank_name.split(" ").count-1]
	#capacity = 20553
	#tankname = tank_name.split(" ")[0]
	#where('locations ILIKE (?)', "%kios%")[0].id
	#where('locations ILIKE (?)',"%#{tankname}%")[0].id
	#where('unit_id=? AND fuel_type_id=? AND capacity=?',depot_id, fuel_type_id, capacity)[0].id  
	where('locations ILIKE (?) AND unit_id=? AND fuel_type_id=? AND capacity=?',"%#{tankno}",depot_id,fuel_type_id, capacity)[0].id	
  end
  
  def self.get_tank2(tank_name, depot_id, fuel_type_id, capacity)
	tankno = tank_name.split("")[tank_name.split("").count-1]
	where('locations ILIKE (?) AND unit_id=? AND fuel_type_id=? AND capacity=?',"%#{tankno}",depot_id,fuel_type_id, capacity)[0].id	
  end
  
  def self.groupped
    groupped_tank=[]
    groupped_tank2=[]
    all_tanks=[]
    FuelTank.all.where('capacity > 0').group_by{|x|x.fuel_type.shortname}.each do |fuelname, fuel_tanks|
      tanks_of_type=[]
      fuel_tanks.each do |tank|
        tanks_of_type << [tank.fuel_tank_details, tank.id]
        all_tanks << [tank.fuel_tank_details, tank.id]
      end
      groupped_tank << [fuelname, tanks_of_type]
    end
    groupped_tank << ['Not Defined', all_tanks]
    groupped_tank
  end
  
end

# == Schema Information
#
# Table name: fuel_tanks
#
#  capacity     :decimal(, )
#  created_at   :datetime
#  fuel_type_id :integer
#  id           :integer          not null, primary key
#  locations    :string(255)
#  maximum      :decimal(, )
#  unit_id      :integer
#  unit_type    :integer
#  updated_at   :datetime
#
