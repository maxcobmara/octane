class FuelType < ActiveRecord::Base
  has_many :fuel_tanks, :foreign_key => "fuel_type_id"
  has_many :fuel_issueds, dependent: :nullify
  has_many :fuel_supplieds, dependent: :nullify
  has_many :add_fuels, dependent: :nullify
  has_many :external_issueds, dependent: :nullify
  has_many :external_supplieds, dependent: :nullify
  
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
  
  
  #---
  
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
