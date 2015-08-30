class Unit < ActiveRecord::Base
  before_save :set_combo_code
  before_destroy :valid_for_removal
  has_ancestry :cache_depth => true

  has_many :fuel_tanks, dependent: :destroy
  has_one :vessel
  has_many :subunits, class_name: "Unit", foreign_key: 'parent_id'
  belongs_to :parent, class_name: "Unit", foreign_key: 'parent_id'
  has_many :vehicle_cards, dependent: :nullify
  has_many :depot_fuels#, dependent: :destroy #only for depot (unit having fuel tanks)
  has_many :unit_fuels#, dependent: :destroy #for all units
  has_many :staffs, dependent: :nullify
  has_many :inden_cards, dependent: :nullify
  has_one  :authorisor_unit, class_name: "Vehicle Assignment"
  has_one  :receiving_unit, class_name: "Vehicle Assignment"
  has_many :fuel_limits
  has_many :fuel_budgets

  scope :is_depot, -> { where("id IN(?)",FuelTank.pluck(:unit_id)) }
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    elsif ancestry_depth == 1 || ancestry_depth == 2 || ancestry_depth == 3 || ancestry_depth == 4
      self.combo_code = parent.combo_code + "-" + code
    else
      self.combo_code = parent.combo_code + code
    end
  end

  def unit_details
    "#{shortname} " + "#{name}"
  end

   def self.get_rmn_unit(unitname)
    where('name ILIKE (?)', unitname)[0].id
  end
  
  def valid_for_removal
    if depot_fuels.count > 0 || unit_fuels.count > 0 || fuel_limits.count > 0 || fuel_budgets.count > 0 || (vessel && vessel.count==1)
      return false
    else
      return true
    end
  end
end

# == Schema Information
#
# Table name: units
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  name           :string(255)
#  shortname      :string(255)
#  updated_at     :datetime
#
