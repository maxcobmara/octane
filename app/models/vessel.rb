class Vessel < ActiveRecord::Base
  belongs_to :unit
  #belongs_to :vessel_type
  belongs_to :vessel_category
  
  validates_presence_of :unit_id
  validates_uniqueness_of :unit_id
end
