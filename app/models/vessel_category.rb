class VesselCategory < ActiveRecord::Base
  has_many :vessels
  belongs_to :vessel_type
  
  def type_category
    description+" ("+vessel_type.description+")"
  end
end
