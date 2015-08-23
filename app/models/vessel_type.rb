class VesselType < ActiveRecord::Base
  #has_many :vessels
  has_many :vessel_categories
end
