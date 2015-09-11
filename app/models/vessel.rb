class Vessel < ActiveRecord::Base
  belongs_to :unit
  belongs_to :vessel_category
  has_many :fuel_transactions, dependent: :destroy
  
  validates_presence_of :unit_id, :pennent_no, :vessel_category_id
  validates_uniqueness_of :unit_id
  validates_numericality_of :pennent_no
  
  def vessel_details
    pennent_no+" | "+unit.name
  end
end
