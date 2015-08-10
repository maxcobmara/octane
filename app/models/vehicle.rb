class Vehicle < ActiveRecord::Base

  after_touch :set_teb_status

  validates_presence_of :reg_no, :status_id
  validates_uniqueness_of :reg_no
  validates_uniqueness_of :chassis_no,  :allow_nil => true, :allow_blank => true, :unless => :chassis_is_dash?
  validates_uniqueness_of :engine_no,   :allow_nil => true, :allow_blank => true
  validates_presence_of :status_id
  validate :process_teb_must_done_via_actionmenu

  has_many :vehicle_nos, :dependent => :nullify
  has_many :vehicle_road_taxes, :dependent => :destroy
  has_many :vehicle_end_of_lives,      :dependent => :restrict_with_error
  has_many :vehicle_fines,      :dependent => :restrict_with_error
  has_many :maintenances,       :dependent => :destroy
  has_many :vehicle_assignment_details, :dependent => :destroy
  has_many :cards, :class_name => "VehicleCard", :dependent => :destroy
  belongs_to :contract
  belongs_to :current_status,    :class_name => "VehicleStatus",       :foreign_key => "status_id"
  belongs_to :vehicleacquired,  :class_name => "AcquiredType",        :foreign_key => "acquired_id"
  belongs_to :manufacturer,     :class_name => "VehicleManufacturer", :foreign_key => "manufacturer_id"
  belongs_to :vehiclecategory,  :class_name => "VehicleCategory",     :foreign_key => "category_id"
  belongs_to :fueltype, :class_name => "FuelType", :foreign_key => "fuel_type_id"
  belongs_to :unittype, :class_name => "UnitType", :foreign_key => "fuel_unit_type_id"

  #txport
  #txporthas_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },:default_url => "/assets/:style/no-photo.gif"

  # The validation has to go after 'has_attached_file'
  #txportvalidates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  def set_teb_status
    @pending    = VehicleEndOfLife.where(confirmed_on: nil).where.not(vehicle_id: nil).pluck(:vehicle_id)
    @confirmed  = VehicleEndOfLife.where.not(confirmed_on: nil).where.not(vehicle_id: nil).pluck(:vehicle_id)
    if @confirmed.include?(id)
      update_attribute(:status_id, VehicleStatus.where(short_name: 'TEB').pluck(:id)[0])
    elsif @pending.include?(id)
      update_attribute(:status_id, VehicleStatus.where(short_name: 'PROSES TEB').pluck(:id)[0])
    end
  end

  attr_accessor :status, :acquired, :category, :register_on, :unit_name, :no_perjawatan, :assignment_date, :kuasa_vro, :vro_start_date, :vro_type, :manufacturer_name, :confirmation_code, :teb_date, :confirmed_on   #for data from excel file

  def full_reg_details
	if vehicle_nos.nil? || vehicle_nos.blank?
		"#{reg_no}"
	else
		"#{vehicle_nos[0].vehicle_army.v_army_no}"+" ("+"#{reg_no}"+")"
	end
  end

  def chassis_is_dash?
    if chassis_no == "-"
      return true
    else
      return false
    end
  end

def self.to_csv(options = {})
  CSV.generate(options) do |csv|
   csv << column_names
   all.each do |vehicle|
     csv << vehicle.attributes.values_at(*column_names)
  end
end
end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)

    #BELOW-works successfully for KEMBARAN_A,B,C,D(1)(1)edited.xls
    #header = spreadsheet.row(2)
    #(3..spreadsheet.last_row).each do |i|
      #row = Hash[[header, spreadsheet.row(i)].transpose]
      #vehicle = find_by_id(row["reg_no"]) || new
      #vehicle.attributes = row.to_hash.slice("reg_no","chassis_no","engine_no","price","reg_on")
      #vehicle.contract_id = 888
      #vehicle.save!
    #end
    #ABOVE-please do not remove above codes yet - 14feb2014

    #BELOW-for TABLE DATA KENDERAAN TLDM.xls
    excel_reg_nos=[]
    vehicles=[]
    excel_year = spreadsheet.cell(3,'A')
    header = spreadsheet.row(5)
    (6..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      vehicle = find_by_id(row["reg_no"]) || new
      vehicle.attributes = row.to_hash.slice("reg_no","category","model","chassis_no","engine_no","price","register_on","status","unit_name","no_perjawatan","assignment_date","kuasa_vro","vro_start_date","vro_type","manufacturer_name", "confirmation_code", "teb_date")

      # retrieve fr excel, assign status_id according to drop down
      unless (vehicle.status.nil? || vehicle.status.blank?)
        vehicle.status_id = VehicleStatus.get_status(vehicle.status)
        unless (vehicle.teb_date.nil? || vehicle.teb_date.blank? || vehicle.teb_date==" " || vehicle.teb_date=="-")
          if vehicle.teb_date.is_a? Date
            vehicle.confirmed_on = vehicle.teb_date
          end
        end
      end
      # retrieve fr excel, assign acquired_id according to drop down
      unless (vehicle.acquired.nil? || vehicle.acquired.blank?)
        vehicle.acquired_id = AcquiredType.get_acquired(vehicle.acquired)
      end
      # retrieve fr excel, assign category_id according to drop down
      unless (vehicle.category.nil? || vehicle.category.blank?)
        vehicle.category_id = VehicleCategory.get_category(vehicle.category)
      end
      # retrieve fr excel, assign manufacturer_id according to drop down
      unless (vehicle.manufacturer_name.nil? || vehicle.manufacturer_name.blank?)
	mfgid = VehicleManufacturer.get_manufacturer(vehicle.manufacturer_name)
	if mfgid!=0
	  vehicle.manufacturer_id = mfgid
	else
	  #nothing assigned
	end
      end

	  # retrieve fr excel, assign unit_id according to drop down & 'perjawatan' info
      unless ((vehicle.unit_name.nil? || vehicle.unit_name.blank? || vehicle.unit_name==" " || vehicle.unit_name=="-") && (vehicle.no_perjawatan.nil? || vehicle.no_perjawatan.blank?))
        unit_id = Unit.get_rmn_unit(vehicle.unit_name.strip)
		v_assignment = VehicleAssignment.find_by_unit_id(unit_id) || VehicleAssignment.new
		if v_assignment.id.nil? || v_assignment.id.blank?
			v_assignment.document_code = vehicle.no_perjawatan
			v_assignment.unit_id = unit_id
			unless (vehicle.assignment_date.nil? || vehicle.assignment_date.blank? || vehicle.assignment_date==" " || vehicle.assignment_date=="-")
				if vehicle.assignment_date.is_a? Date
					v_assignment.document_date = vehicle.assignment_date
				end
			end
			v_assignment.save!
			ind = 0
        else
			ind = vehicle.vehicle_assignment_details.count
		end
		unless ((vehicle.kuasa_vro.nil? || vehicle.kuasa_vro.blank? || vehicle.kuasa_vro==" " || vehicle.kuasa_vro=="-")&&(vehicle.vro_start_date.nil? || vehicle.vro_start_date.blank? || vehicle.vro_start_date==" " || vehicle.vro_start_date=="-")&&(vehicle.vro_type.nil? || vehicle.vro_type.blank? || vehicle.vro_type==" " || vehicle.vro_type=="-"))
			vehicle.vehicle_assignment_details.new
			vehicle.vehicle_assignment_details[ind].vehicle_assignment_id = v_assignment.id
			vehicle.vehicle_assignment_details[ind].release_no = vehicle.kuasa_vro
			vehicle.vehicle_assignment_details[ind].assigned_on = vehicle.vro_start_date
			vehicle.vehicle_assignment_details[ind].release_type = VehicleAssignmentDetail.get_vro_type(vehicle.vro_type.strip.capitalize)
		end
	  end

      #to add other date checking - format dd-mm-yyyy vs DB date format
      unless (vehicle.register_on.nil? || vehicle.register_on.blank? || vehicle.register_on==" " || vehicle.register_on=="NIL")
        #if celltype is STRING
        if (vehicle.register_on.is_a? String)
          #DO NOTHING
        #if celltype is DATE
        elsif vehicle.register_on.is_a? Date
          vehicle.reg_on = vehicle.register_on
        end
      end

      exist_reg_no = excel_reg_nos.include?(vehicle.reg_no)
      unless (vehicle.reg_no.nil? || vehicle.reg_no.blank? || vehicle.reg_no == " " || vehicle.reg_no == "-")
        if !exist_reg_no
          excel_reg_nos<< vehicle.reg_no
          if vehicle.reg_no.is_a? Numeric
            vehicle.reg_no = vehicle.reg_no.to_i
          end
          #vehicle.save!    #use this line or line 59(vehicles=[]) & line 94(vehicles<<vehicle) & line 98(return vehicles)
          vehicles<< vehicle #all valid one...will be assign to array & send for data saving
        end
      end
    end
    return vehicles
  end


  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.get_invalid(vehicle_list)
    @invalid_vehicles = []
    vehicle_list.each do |vehiclesub|
      unless vehiclesub.valid?
        @invalid_vehicles<< vehiclesub
      end
	  end
    return @invalid_vehicles
  end

  def self.get_vehicle(reg_no)
	where('reg_no LIKE (?)',reg_no)[0].id
  end

  def process_teb_must_done_via_actionmenu
    status_name = VehicleStatus.find(status_id).short_name
    if status_name=='PROSES TEB'
      if vehicle_end_of_lives.count < 1
        errors.add(:base, I18n.t('vehicles.proses_teb_action_menu'))
      end
    end
  end
  
  def self.groupped
    groupped_vehicle=[]
    Vehicle.all.group_by(&:fuel_type_id).each do |fuelid, vehicles|
      vehicles_of_type=[]
      vehicles.sort_by(&:reg_no).each do |vehicle|
        vehicles_of_type << [vehicle.reg_no, vehicle.id]
      end
      unless fuelid==nil
        fuelname=FuelType.find(fuelid).name
      else
        fuelname='Not Defined'
      end
      groupped_vehicle << [fuelname, vehicles_of_type] 
    end
    groupped_vehicle
  end

end

# == Schema Information
#
# Table name: vehicles
#
#  acquired_id        :integer
#  acquired_on        :date
#  category_id        :integer
#  chassis_no         :string(255)
#  contract_id        :integer
#  created_at         :datetime
#  engine_no          :string(255)
#  id                 :integer          not null, primary key
#  manufacturer_id    :integer
#  manufacturer_year  :string(255)
#  model              :string(255)
#  photo_content_type :string(255)
#  photo_file_name    :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  price              :decimal(10, 2)
#  reg_no             :string(20)
#  reg_on             :date
#  status_id          :integer
#  updated_at         :datetime
#
