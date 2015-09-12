class VesselType < ActiveRecord::Base
  before_destroy :valid_for_removal
  has_many :vessel_categories
  
  def valid_for_removal
    if vessel_categories.count > 0
      return false
    else
      return true
    end
  end
end
