class FuelType < ActiveRecord::Base
  before_destroy :valid_for_removal
  has_many :fuel_tanks
  has_many :vehicles, dependent: :nullify
  has_many :fuel_limits
  has_many :fuel_budgets
  has_many :fuel_transactions
  has_many :add_fuels
  has_many :external_supplieds
  has_many :external_issueds
  has_many :fuel_issueds
  has_many :fuel_supplieds

  scope :main_use, -> { where(id: [FuelTank.where('fuel_type_id is not null').pluck(:fuel_type_id)])} #for use in Add Fuel & Use Fuel

  def self.exclude_petrol_diesel
    where('name LIKE (?) OR name LIKE (?)','PETROL','DIESEL').pluck(:id)
  end

  def self.get_fuel_type(fueltype)
    where('shortname ILIKE (?)', fueltype)[0].id
  end

  def self.get_fuel_type2(fr_excel,arr_fr_excel)
    fueltypes=where('shortname ILIKE (?)',"%#{fr_excel}%")#.squeeze(" ").strip)
    if fueltypes.count > 0
      return fueltypes[0].id
    else
      unless arr_fr_excel.include?(fr_excel)
        fueltype = find_by_shortname(fr_excel) || new
        fueltype.shortname = fr_excel
        fueltype.save!
        return fueltype.id
      end
    end
  end

  def valid_for_removal
    if fuel_tanks.count > 0 || fuel_limits.count > 0|| fuel_budgets.count > 0 || fuel_transactions.count > 0 || add_fuels.count > 0 || external_issueds.count > 0 || external_supplieds.count > 0 ||  fuel_issueds.count > 0 || fuel_supplieds.count > 0 
      return false
    else
      return true
    end
  end
  
end

# == Schema Information
#
# Table name: fuel_types
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  shortname  :string(255)
#  updated_at :datetime
#
