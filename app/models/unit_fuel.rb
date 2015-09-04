class UnitFuel < ActiveRecord::Base
  before_save :set_default_value

  belongs_to :unit, :foreign_key => "unit_id"
  has_many :add_fuels, dependent: :destroy
  accepts_nested_attributes_for :add_fuels, allow_destroy: true, reject_if: proc { |add_fuels| add_fuels[:quantity].blank? }
  has_many :external_issueds, dependent: :destroy
  accepts_nested_attributes_for :external_issueds, allow_destroy: true, reject_if: proc { |external_issueds| external_issueds[:quantity].blank? }
  has_many :external_supplieds, dependent: :destroy
  accepts_nested_attributes_for :external_supplieds, allow_destroy: true, reject_if: proc { |external_supplieds| external_supplieds[:quantity].blank? }

  validates_presence_of :unit_id, :issue_date
  validate :valid_unique_record
  
  def set_default_value
    self.d_vessel = 0 if d_vessel.blank?
    self.d_vehicle = 0 if d_vehicle.blank?
    self.d_misctool = 0 if d_misctool.blank?
    self.d_boat = 0 if d_boat.blank?
    self.p_vehicle = 0 if p_vehicle.blank?
    self.p_misctool = 0 if p_misctool.blank?
    self.p_boat = 0 if p_boat.blank?
  end

  def month_unit
    "#{unit.name} "+"#{issue_date.strftime("%b")} "+"#{issue_date.year}"
  end

  #this is really bad should have another table with type and quantity. too late now
  def self.diesel_usage(unit_fuel)
    return (unit_fuel.d_vessel+unit_fuel.d_vehicle+unit_fuel.d_misctool+unit_fuel.d_boat).to_i.to_s+" LTR"
  end

  def self.petrol_usage(unit_fuel)
    return (unit_fuel.p_vehicle+unit_fuel.p_misctool+unit_fuel.p_boat).to_i.to_s+" LTR"
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
     csv << column_names
     all.each do |unit_fuel|
       csv << unit_fuel.attributes.values_at(*column_names)
    end
  end
  end

  def valid_unique_record
    if issue_date
      exist_unitfuel=UnitFuel.where('unit_id=? and issue_date >=? and issue_date <=?', unit_id, issue_date.beginning_of_month, issue_date.end_of_month)
      if exist_unitfuel.count > 0
        errors.add(:base, 'Record already exist. Only 1 record of Unit Fuel allowed for each Unit / Depot in a month.')
      end
    end
  end

end

# == Schema Information
#
# Table name: unit_fuels
#
#  created_at :datetime
#  d_boat     :decimal(, )
#  d_misctool :decimal(, )
#  d_vehicle  :decimal(, )
#  d_vessel   :decimal(, )
#  id         :integer          not null, primary key
#  issue_date :date
#  p_boat     :decimal(, )
#  p_misctool :decimal(, )
#  p_vehicle  :decimal(, )
#  unit_id    :integer
#  updated_at :datetime
#
