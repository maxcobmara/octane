class ExternalSupplied < ActiveRecord::Base
  belongs_to :resource, :class_name => "Unit", :foreign_key => "source"
  belongs_to :unit_fuel, :foreign_key => "unit_fuel_id"
  belongs_to :unit_type, :foreign_key => "unit_type_id"
  belongs_to :fuel_type, :foreign_key => "fuel_type_id"
end

# == Schema Information
#
# Table name: external_supplieds
#
#  created_at   :datetime
#  fuel_type_id :integer
#  id           :integer          not null, primary key
#  quantity     :decimal(, )
#  source       :integer
#  unit_fuel_id :integer
#  unit_type_id :integer
#  updated_at   :datetime
#
