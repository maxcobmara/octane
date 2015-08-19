class VehicleCategory < ActiveRecord::Base
  has_many :vehicles
  
  def self.get_category(fr_excel)
    VehicleCategory.all.each do |category|
      if fr_excel.size > 12
        return category.id if fr_excel == category.description
      else
        return category.id if fr_excel == category.short_name 
      end
    end
  end
  
  scope :cars, -> { where('description ILIKE(?) or description ILIKE(?)', '%kereta%', '%pajero%')}
  scope :lorries, -> { where('description ILIKE(?) or description ILIKE(?)', '%trak%', '%lori%') }
  scope :busses, -> { where('description ILIKE(?)', '%bas%') }
end

# == Schema Information
#
# Table name: vehicle_categories
#
#  created_at  :datetime
#  description :string(255)
#  id          :integer          not null, primary key
#  short_name  :string(12)
#  updated_at  :datetime
#
