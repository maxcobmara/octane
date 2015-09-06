class IndenUsage < ActiveRecord::Base
  belongs_to :inden_card, foreign_key: "inden_card_id"
  belongs_to :unit_fuel, foreign_key: "unit_fuel_id"
end

# == Schema Information
#
# Table name: inden_usages
#
#  created_at       :datetime
#  diesel_ltr       :decimal(, )
#  diesel_price     :decimal(, )
#  id               :integer          not null, primary key
#  inden_card_id    :integer
#  issue_date       :date
#  petrol_ltr       :decimal(, )
#  petrol_price     :decimal(, )
#  petronal_p_price :decimal(, )
#  petronas_d_ltr   :decimal(, )
#  petronas_d_price :decimal(, )
#  petronas_p_ltr   :decimal(, )
#  updated_at       :datetime
#
