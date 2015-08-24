class IndenCard < ActiveRecord::Base
  belongs_to :staff, foreign_key: "staff_id"
  belongs_to :unit, foreign_key: "unit_id"
  has_many :inden_usages, dependent: :destroy
  accepts_nested_attributes_for :inden_usages, allow_destroy: true, reject_if: proc { |inden_usages| inden_usages[:issue_date].blank? }
  
  validates_presence_of :serial_no
  validates_presence_of :staff_id, :if => :ru_staff?
  validates_presence_of :unit_id, :if => :must_assign_unit?
  
  def must_assign_unit?
    ru_staff == false
  end
end

# == Schema Information
#
# Table name: inden_cards
#
#  created_at    :datetime
#  daily_limit   :decimal(, )
#  end_date      :date
#  id            :integer          not null, primary key
#  issue_date    :date
#  monthly_limit :decimal(, )
#  ru_staff      :boolean
#  serial_no     :string(255)
#  staff_id      :integer
#  start_date    :date
#  unit_id       :integer
#  updated_at    :datetime
#
