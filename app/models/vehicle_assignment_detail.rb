class VehicleAssignmentDetail < ActiveRecord::Base
  belongs_to :vehicle_assignment, :foreign_key => 'vehicle_assignment_id'
  belongs_to :vehicle, :foreign_key => 'vehicle_id'
  
  validates_uniqueness_of :vehicle_id, :scope => [:assigned_on, :assignment_end]
  #validates_presence_of :vehicle_id, :assigned_on, :release_no ,:release_type	#unremark this line will fail Vehicle Import (validation added in vehicle.rb)
  
  RELEASETYPE = [
           #  Displayed       stored in db
           ["Perjawatan",1],
           ["Penggantian",2],
		   ["Tambahan",3],
		   ["Pinjaman",4]
]
   
   def self.get_vro_type(vro_type)
	((VehicleAssignmentDetail::RELEASETYPE.find_all{|disp, value| disp == vro_type}).map {|disp, value| value})[0]
   end
end

# == Schema Information
#
# Table name: vehicle_assignment_details
#
#  assigned_on           :date
#  assignment_end        :date
#  created_at            :datetime
#  id                    :integer          not null, primary key
#  release_no            :string(255)
#  release_type          :integer
#  remark                :string(255)
#  staff_id              :integer
#  updated_at            :datetime
#  vehicle_assignment_id :integer
#  vehicle_id            :integer
#
