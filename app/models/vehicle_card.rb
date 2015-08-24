class VehicleCard < ActiveRecord::Base
	#has_many :vehicles, :foreign_key => "vehicle_id"
  belongs_to :vehicle, foreign_key: "vehicle_id"
  belongs_to :card_holder, class_name: "Staff", foreign_key: "staff_id"
  belongs_to :unit, foreign_key: "unit_id"
  
  validates_presence_of :staff_id, :vehicle_id
end

# == Schema Information
#
# Table name: vehicle_cards
#
#  created_at      :datetime
#  expired_date    :date
#  id              :integer          not null, primary key
#  issue_date      :date
#  serial_no       :string(255)
#  smart_tag       :boolean
#  smarttag_serial :string(255)
#  staff_id        :integer
#  start_date      :date
#  unit_id         :integer
#  updated_at      :datetime
#  vehicle_id      :integer
#