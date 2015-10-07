class Staff < ActiveRecord::Base
  has_many :contracts,                            foreign_key: "issued_by"
  has_many :authorisations, class_name: "Staff",  foreign_key: "authorised_by"
  has_many :inden_cards, dependent: :nullify  #1 card only
  has_one :vehicle_card, dependent: :nullify
  belongs_to :rank, :foreign_key => "rank_id" 
  belongs_to :unit, foreign_key: "unit_id"  
  belongs_to :position, :foreign_key => "position_id"
  belongs_to :expertise, :foreign_key => "expertise_id"
  validates_presence_of :id_no, :name, :rank_id, :gender, :religion, :unit_id
  validates_presence_of :position_id , :if => :rank_officer?
  validates_presence_of :expertise_id, :if => :rank_staff?
  has_one :user

  def staff_details
    "#{id_no} " + "#{name}".gsub(/\w+/, &:capitalize)
  end
  
  def rank_officer?
    !rank_id.nil? && rank.rate > 2
  end
  
  def rank_staff?
    !rank_id.nil? && rank.rate < 3
  end
  
  GENDER = [
  #  Displayed       stored in db
          [ "Male",  1],
          [ "Female", 2]
  ]

  RELIGION = [
  #  Displayed       stored in db
          ["Islam",   1],
          ["Sikh",    2],
          ["Others",  3]
  ]

end

# == Schema Information
#
# Table name: staffs
#
#  created_at   :datetime
#  expertise_id :integer
#  gender       :integer
#  id           :integer          not null, primary key
#  id_no        :string(255)
#  name         :string(255)
#  position_id  :integer
#  rank_id      :integer
#  religion     :integer
#  unit_id      :integer
#  updated_at   :datetime
#
