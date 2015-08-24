class VesselType < ActiveRecord::Base
  has_many :vessel_categories
end
