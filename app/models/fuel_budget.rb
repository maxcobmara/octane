class FuelBudget < ActiveRecord::Base
  belongs_to :unit
  belongs_to :fuel_type
  belongs_to :unit_type
  
  validates_presence_of :unit_id, :fuel_type_id, :unit_type_id, :amount
  
  scope :petrol, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'PETROL')) }
  scope :diesel, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'DIESEL')) }
  scope :avtur, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'AVTUR')) }
  scope :avcat, -> { where(fuel_type: FuelType.where('shortname LIKE (?)', 'AVCAT')) }
end
