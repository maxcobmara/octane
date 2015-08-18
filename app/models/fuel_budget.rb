class FuelBudget < ActiveRecord::Base
  belongs_to :unit
  belongs_to :fuel_type
  belongs_to :unit_type
end
