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
  
end
