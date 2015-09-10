class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :staff#, :foreign_key => "staff_id"

  #stuff for roles
  serialize :roles, Hash

  def user_roles=(value)
    roles[:user_roles] = value
  end

  def user_roles
    roles[:user_roles]
  end

  def role_symbols
    user_roles.find_all{|key, value| value == '1'}.map(&:first).map(&:to_sym) rescue []
  end
  
  def role_strings
    user_roles.find_all{|key, value| value == '1'}.map(&:first).join(", ") rescue ""
  end

end

# == Schema Information
#
# Table name: users
#
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime
#
