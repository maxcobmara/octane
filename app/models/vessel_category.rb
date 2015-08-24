class VesselCategory < ActiveRecord::Base
  has_many :vessels
  belongs_to :vessel_type
  
  validates_presence_of :vessel_type_id, :short_name, :description
  
  def type_category
    description+" ("+vessel_type.description+")"
  end
end
