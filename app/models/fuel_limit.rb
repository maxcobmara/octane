class FuelLimit < ActiveRecord::Base
  belongs_to :unit
  belongs_to :limit_unit_type, :class_name => "UnitType", :foreign_key => "limit_unit_type_id"
  belongs_to :fuel_type
  belongs_to :fuel_unit_type, :class_name => "UnitType", :foreign_key => "fuel_unit_type_id"
end
