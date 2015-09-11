class VesselCategory < ActiveRecord::Base
  before_destroy :valid_for_removal
  has_many :vessels
  belongs_to :vessel_type
  
  validates_presence_of :vessel_type_id, :short_name, :description
  
  def type_category
    description+" ("+vessel_type.description+")"
  end
  
  def valid_for_removal
    if vessels.count > 0
      return false
    else
      return true
    end
  end
end
