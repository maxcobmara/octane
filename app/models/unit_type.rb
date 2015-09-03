class UnitType < ActiveRecord::Base
  before_destroy :valid_for_removal
  has_many :fuel_tanks, :foreign_key => "unit_type"
  has_many :fuel_limits, :foreign_key => "limit_unit_type_id"
  has_many :fuel_budgets
  has_many :fuel_transactions, :foreign_key => "fuel_unit_type_id"
  has_many :add_fuels
  has_many :external_supplieds
  has_many :external_issueds
  has_many :fuel_issueds
  has_many :fuel_supplieds
  has_many :fuel_balances

  def self.get_type(fr_excel,arr_fr_excel)
    utype_desc = UnitType.get_type_desc(fr_excel)
    unittypes=where('short_name ILIKE (?)',utype_desc)
    if unittypes.count > 0
      return unittypes[0].id
    else
      unless arr_fr_excel.include?(utype_desc)
        unittype = where('short_name ILIKE (?)',utype_desc)[0] || new
        unittype.short_name = utype_desc
        unittype.save!
        return unittype.id
      end
    end
  end

  def self.get_type_desc(mparts)
    fulldesc_arr = mparts.split(" ")                        # ["partsA", "01nos"] if ..... partsA 01nos   @ "partsA 01 nos"
    last_item = fulldesc_arr[fulldesc_arr.count-1]          # "01nos"                                     @ "nos"
    qty_type_arr = last_item.scan(/\d+|\D+/)                # ["01", "nos"]                               @ "nos"
    qty_type_arr_count = qty_type_arr.count                 # ["01", "nos"].count ==> 2                   @ 1
    if qty_type_arr_count>1
      utype_desc = qty_type_arr[1]
    else
      utype_desc = last_item
    end
    utype_desc
  end
  
  def valid_for_removal
    if fuel_tanks.count > 0 || fuel_limits.count > 0|| fuel_budgets.count > 0 || fuel_transactions.count > 0 || add_fuels.count > 0  || external_issueds.count > 0 || external_supplieds.count > 0 || fuel_issueds.count > 0 || fuel_supplieds.count > 0 || fuel_balances.count > 0
      return false
    else
      return true
    end
  end

end

# == Schema Information
#
# Table name: unit_types
#
#  created_at  :datetime
#  description :string(255)
#  id          :integer          not null, primary key
#  short_name  :string(255)
#  updated_at  :datetime
#
