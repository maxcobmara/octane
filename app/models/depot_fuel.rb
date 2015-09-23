class DepotFuel < ActiveRecord::Base
  belongs_to :depot, class_name: "Unit", :foreign_key => "unit_id"
  has_many :fuel_issueds, dependent: :destroy
  accepts_nested_attributes_for :fuel_issueds, allow_destroy: true, reject_if: proc { |fuel_issueds| fuel_issueds[:quantity].blank? }
  has_many :fuel_supplieds, dependent: :destroy
  accepts_nested_attributes_for :fuel_supplieds, allow_destroy: true, reject_if: proc { |fuel_supplieds| fuel_supplieds[:quantity].blank? }
  has_many :fuel_balances, dependent: :destroy
  accepts_nested_attributes_for :fuel_balances, allow_destroy: true, reject_if: proc { |fuel_balances| fuel_balances[:fuel_tank_id].blank? }
  
  validates_presence_of :unit_id, :issue_date
  validate :valid_unique_record, :issue_date_not_later_today
  
  attr_accessor :tank, :current, :current2, :current3, :supplieds, :issueds #:capacity, :capacity2, :capacity3, #:prev_balance - not use

  def month_depot
    "#{depot.name} "+"#{issue_date.strftime("%b")} "+"#{issue_date.year}"
  end 
  
  def self.balance_before(depot_fuel)
    #depot_fuel = DepotFuel.find(depot_fuel_id)
    @begin_last_month = depot_fuel.issue_date.last_month.at_beginning_of_month
    @end_last_month = depot_fuel.issue_date.last_month.at_end_of_month
    @current_unit = depot_fuel.unit_id
    @prevmonth_depot_fuel=DepotFuel.where('unit_id=? AND issue_date >=? AND issue_date <=?', @current_unit, @begin_last_month, @end_last_month)
    @balance_before = []
    depot_fuel.depot.fuel_tanks.group_by(&:fuel_type_id).sort.each do |fuel_type, items|
        @tanks_by_type = depot_fuel.depot.fuel_tanks.where('fuel_type_id=?',fuel_type).pluck(:id)
        if @prevmonth_depot_fuel.count!=0
            @bal_of_tank = @prevmonth_depot_fuel[0].fuel_balances.where('fuel_tank_id IN (?)',@tanks_by_type).sum(:current) 
            @balance_before << @bal_of_tank if @bal_of_tank!=0
        else
            @balance_before << 0
        end
    end
    return @balance_before
  end

  def supplied(fuel_type)
    fuel_supplieds.where(fuel_type_id: fuel_type).sum(:quantity).to_i
  end
  
  def issued(fuel_type)
    fuel_issueds.where('fuel_type_id=?',fuel_type).sum(:quantity).to_i
  end
  
  #tank balance
  def balance(fuel_type) 
    tanks_by_type = depot.fuel_tanks.where('fuel_type_id=?',fuel_type).pluck(:id)
    return fuel_balances.where('fuel_tank_id IN (?)', tanks_by_type).sum(:current).to_i
  end
  
  def self.import(file) 
	spreadsheet = open_spreadsheet(file) 
	spreadsheet.default_sheet = spreadsheet.sheets.first
	
	#first sheet : Fuel Balances
	excel_month = spreadsheet.cell(4,'B')
	excel_year = spreadsheet.cell(5,'B')
	depot_name = spreadsheet.cell(11,'B')
	depot = Unit.where('name ILIKE (?)',depot_name)[0]
    if depot
	depot_id = depot.id
	
	storage_tank_exist = FuelTank.where('unit_id=?',depot_id)
	storage_tank_exist_count= storage_tank_exist.count
	storage_tank_exist_fueltype_count = storage_tank_exist.map(&:fuel_type_id).uniq.count
	storage_tank_excel=[]
	tank_naming_err=[]
	#capacity_err=[]
	(11..spreadsheet.last_row).each do |i|
		tank_excel = spreadsheet.cell(i,'C')
		unless (tank_excel.nil? || tank_excel.blank? || tank_excel==" " || tank_excel=="-")
			storage_tank_excel<< tank_excel
			lastitem = tank_excel.split("")[tank_excel.split("").count-1]
			if (lastitem.is_a? Numeric) 	
			elsif (lastitem.is_a? String)
			else	#if not a number or string
				tank_naming_err<< tank_excel
			end
		end
		#capacity_val = spreadsheet.cell(i,'D')
		current_val = spreadsheet.cell(i,'F')
		unless (current_val.nil? || current_val.blank? || current_val==" " || current_val=="-")
			#if (capacity_val.nil? || capacity_val.blank? || capacity_val==" " || capacity_val=="-")
			#  capacity_err<< capacity_val
			#end
		end
	end
	if storage_tank_exist_count == storage_tank_excel.count
		storage_tank_count_match = true 
	else
		storage_tank_count_match = false
	end
	
	#START-part of : second sheet - to compare fuel type counts in 1st sheet & 2nd sheet
	fueltype_name=[]
	second_sheet = spreadsheet.sheets.second							#also required for lines 209-210
	last_row_second = spreadsheet.last_row(second_sheet) 				#also required for lines 209-210
	(11..last_row_second).each do |i|
		fuelkiosk = spreadsheet.cell(i,'B',second_sheet)
		unless (fuelkiosk.nil? || fuelkiosk.blank? || fuelkiosk==" " || fuelkiosk=="-")
			fueltype_depot_name = fuelkiosk.split(" ")[0]
			if fueltype_depot_name!="Depot"
				if FuelType.all.pluck(:shortname).include?(fueltype_depot_name) 	#wrong naming of (fuel tank category-BFI, KIOSK - record will be omitted from the list. 
					fueltype_name << fueltype_depot_name
				end
			end
		end
	end
	fueltype_count_sheet2 = fueltype_name.uniq.count
	#END-part of : second sheet
	
	#fuel type count at storage tanks (DB) must match fuel type count in excel (sheet 2 - fuel supplieds & fuel issueds)
	if storage_tank_exist_fueltype_count == fueltype_count_sheet2 			
		fueltype_count_match = true
	else
		fueltype_count_match = false
	end
	
	if storage_tank_count_match==true && tank_naming_err.count==0 && fueltype_count_match==true #&& capacity_err.count==0 
		unless (excel_month.nil? || excel_month.blank? || excel_month == " " || excel_month == "-") && (excel_year.nil? || excel_year.blank? || excel_year == " " || excel_year == "-") 

			begin_month = Date.new(excel_year.to_i,excel_month.to_i,1)
			next_month = begin_month+1.month
			end_day = 31 if (excel_month == 1)||(excel_month == 3)||(excel_month == 5)||(excel_month == 7)||(excel_month == 8)||(excel_month == 10)||(excel_month == 12)
			end_day = 28 if (excel_month == 2)
			end_day = 30 if (excel_month == 4)||(excel_month == 6)||(excel_month == 8)||(excel_month == 11)
			
			header = spreadsheet.row(10) 
			(11..spreadsheet.last_row).each do |i|
				row = Hash[[header, spreadsheet.row(i)].transpose] 
				df = where('unit_id =? AND issue_date>=? AND issue_date<?', depot_id, begin_month, next_month)[0] || new
				df.unit_id = depot_id
				df.attributes = row.to_hash.slice("tank","current","current2","current3")#,"capacity","capacity2","capacity3" )
			
				#for new depot fuel only
				if df.id.nil? || df.id.blank?
					df.issue_date = Date.new(excel_year.to_i,excel_month.to_i,end_day)
				end
		
				#repeating fields - fuel_balances - petrol
				unless (df.current.nil? || df.current.blank? || df.current == " " || df.current == "-") 
					fuel_type_name="petrol"
					fuel_type_id=FuelType.get_fuel_type(fuel_type_name) #1 
					#capacity = df.capacity
					ftank_id = FuelTank.get_tank(df.tank, depot_id, fuel_type_id)#, capacity)
					if df.id.nil? || df.id.blank?
						ind = 0
						exist_balances = false
					else
						ind = df.fuel_balances.count
						fuel_tank_ids = df.fuel_balances.map(&:fuel_tank_id)
						exist_balances = fuel_tank_ids.include?(ftank_id)  #fuel_tank_ids.include?(13)   #df.tank? FuelTank.get_tank(df.tank, depot_id, fuel_type_id)
					end
					if exist_balances == false
						df.fuel_balances.new
						df.fuel_balances[ind].current = df.current
						df.fuel_balances[ind].unit_type_id = FuelTank.find(ftank_id).unit_type
						df.fuel_balances[ind].fuel_tank_id = ftank_id	
					end
				end
		
				#repeating fields - fuel_balances - diesel
				unless (df.current2.nil? || df.current2.blank? || df.current2 == " " || df.current2 == "-") 
					fuel_type_name="diesel"
					fuel_type_id=FuelType.get_fuel_type(fuel_type_name) 
					#capacity2 = df.capacity2
					ftank_id = FuelTank.get_tank(df.tank, depot_id, fuel_type_id)#, capacity2)
					if df.id.nil? || df.id.blank?
						ind = 0
						exist_balances2 = false
					else
						ind = df.fuel_balances.count
						fuel_tank_ids = df.fuel_balances.map(&:fuel_tank_id)
						exist_balances2 = fuel_tank_ids.include?(ftank_id)
					end
					if exist_balances2 == false
						df.fuel_balances.new
						df.fuel_balances[ind].current = df.current2
						df.fuel_balances[ind].unit_type_id = FuelTank.find(ftank_id).unit_type
						df.fuel_balances[ind].fuel_tank_id = ftank_id
					end
				end
		
				#repeating fields - fuel_balances - avcat/avtur
				fuel_types=[]
				unless (df.current3.nil? || df.current3.blank? || df.current3 == " " || df.current3 == "-") 
					#capacity3 = df.capacity3
					unless (df.tank.nil? || df.tank.blank?)
						fuel_type_name=df.tank.split(" ")[0] #eg. Avcat H1, Avtur H2 etc
						fuel_type_id=FuelType.get_fuel_type2(fuel_type_name, fuel_types)
						fuel_types<< fuel_type_name if FuelType.all.pluck(:shortname).include?(fuel_type_name)
					end
					ftank_id = FuelTank.get_tank2(df.tank, depot_id, fuel_type_id)#, capacity3)
					unless (ftank_id.nil? || ftank_id.blank? || ftank_id==" " || ftank_id=="-")	
						if df.id.nil? || df.id.blank?
							ind = 0
							exist_balances3 = false
						else
							ind = df.fuel_balances.count
							fuel_tank_ids = df.fuel_balances.map(&:fuel_tank_id)
							exist_balances3 = fuel_tank_ids.include?(ftank_id)
						end
						if exist_balances3 == false
							df.fuel_balances.new
							df.fuel_balances[ind].current = df.current3
							df.fuel_balances[ind].unit_type_id = FuelTank.find(ftank_id).unit_type
							df.fuel_balances[ind].fuel_tank_id = ftank_id	
						end
					end
				end
				df.save!	
			end	#end for 11....spreadsheet...
			
			#second sheet: ===START===(fuel issueds & fuel supplieds)=========================================== 
			#try_check_val = spreadsheet.cell(12,'C',spreadsheet.sheets.second)		#sample working one!
			#second_sheet = spreadsheet.sheets.second								#moved to line 94-95
			#last_row_second = spreadsheet.last_row(second_sheet) 					#moved to line 94-95
			header2 = spreadsheet.row(10,second_sheet) 
			
			excel_month2 = spreadsheet.cell(4,'B', second_sheet)
			excel_year2 = spreadsheet.cell(5,'B', second_sheet)
			depot_name2 = spreadsheet.cell(11,'B', second_sheet)
			depot_id2 = Unit.where('name ILIKE (?)',depot_name)[0].id
	
			begin_month2 = Date.new(excel_year2.to_i,excel_month2.to_i,1)
			next_month2 = begin_month+1.month
			
			(11..last_row_second).each do |i|
				row2 = Hash[[header2, spreadsheet.row(i,second_sheet)].transpose]
				df2 = where('unit_id =? AND issue_date>=? AND issue_date<?', depot_id2, begin_month2, next_month2)[0] #|| new
				df2.attributes = row2.to_hash.slice("supplieds","issueds") #"prev_balance",
				#----fuel_supplieds section
				unless (df2.supplieds.nil? || df2.supplieds.blank? || df2.supplieds==" " || df2.supplieds=="-")
					fueltype_row = i-1
					fueltype_name = spreadsheet.cell(fueltype_row,'B', second_sheet).split(" ")[0]
					ftype_id = FuelType.get_fuel_type(fueltype_name) #1
					if df2.fuel_supplieds.nil? || df2.fuel_supplieds.blank? #df2.id.nil? || df2.id.blank?
						ind = 0
						exist_supplieds = false
					else
						ind = df2.fuel_supplieds.count
						fuel_type_ids = df2.fuel_supplieds.map(&:fuel_type_id)
						exist_supplieds = fuel_type_ids.include?(ftype_id)  
					end
					if exist_supplieds == false
						df2.fuel_supplieds.new
						df2.fuel_supplieds[ind].fuel_type_id = ftype_id 
						df2.fuel_supplieds[ind].quantity = df2.supplieds
						
						#check for unit_type_id when fuel_type_id is xxx
						fuel_tank_ids = df2.fuel_balances.map(&:fuel_tank_id).uniq
						if fuel_tank_ids.count==1
							fuel_tank_w_ftype_id = FuelTank.where('id IN (?) AND fuel_type_id=?',fuel_tank_ids, ftype_id)
						else
							fuel_tank_w_ftype_id = FuelTank.where('id IN (?) AND fuel_type_id=?',fuel_tank_ids, ftype_id)[0]
						end
						#retrieve unit_type_id from fuel_tank which contains fuel of type xxx
						unless fuel_tank_w_ftype_id.nil? || fuel_tank_w_ftype_id.blank?
							df2.fuel_supplieds[ind].unit_type_id = fuel_tank_w_ftype_id.unit_type
						end
					else
						#retrieve & total up additional values for similar fuel_type_id 
						fs = df2.fuel_supplieds.find_by_fuel_type_id(ftype_id)
						prev_total = fs.quantity
						fs.quantity = df2.supplieds+prev_total
						fs.save!
					end
				end
				
				#----fuel_issueds section
				unless (df2.issueds.nil? || df2.issueds.blank? || df2.issueds==" " || df2.issueds=="-")
					fueltype_row = i-1
					fueltype_name = spreadsheet.cell(fueltype_row,'B', second_sheet).split(" ")[0]
					ftype_id = FuelType.get_fuel_type(fueltype_name) #1
					if df2.fuel_issueds.nil? || df2.fuel_issueds.blank? #df2.id.nil? || df2.id.blank?
						ind = 0
						exist_issueds = false
					else
						ind = df2.fuel_issueds.count
						fuel_type_ids = df2.fuel_issueds.map(&:fuel_type_id)
						exist_issueds = fuel_type_ids.include?(ftype_id)  
					end
					if exist_issueds == false
						df2.fuel_issueds.new
						df2.fuel_issueds[ind].fuel_type_id = ftype_id 
						df2.fuel_issueds[ind].quantity = df2.issueds
						
						#check for unit_type_id when fuel_type_id is xxx
						fuel_tank_ids = df2.fuel_balances.map(&:fuel_tank_id).uniq
						if fuel_tank_ids.count==1
							fuel_tank_w_ftype_id = FuelTank.where('id IN (?) AND fuel_type_id=?',fuel_tank_ids, ftype_id)
						else
							fuel_tank_w_ftype_id = FuelTank.where('id IN (?) AND fuel_type_id=?',fuel_tank_ids, ftype_id)[0]
						end
						#retrieve unit_type_id from fuel_tank which contains fuel of type xxx
						unless fuel_tank_w_ftype_id.nil? || fuel_tank_w_ftype_id.blank?
							df2.fuel_issueds[ind].unit_type_id = fuel_tank_w_ftype_id.unit_type
						end
					else
						#retrieve & total up additional values for similar fuel_type_id 
						fi = df2.fuel_issueds.find_by_fuel_type_id(ftype_id)
						prev_total2 = fi.quantity
						fi.quantity = df2.issueds+prev_total2
						fi.save!
					end
				end

				df2.save!
			end
			#second sheet: ===END===(fuel issueds & fuel supplieds)===========================================
		
		else #if month & year cell in excel table is blank!... 
			return "invalid_month_and_year"
		end #end for unless (excel_month.nil?...
	else
		msg_err=""
		msg_err+="stc" if storage_tank_count_match==false
		msg_err+=" tn" if tank_naming_err.count>0 
		#msg_err+=" cap" if capacity_err.count>0
		msg_err+=" ftcm" if fueltype_count_match==false
		return msg_err
	end # end of - if storage_tank_count_match, tank_naming_err, fueltype_count etc.  ##30Aug2015-capacity_err : removed
    else
      return "depot_not_exist"
    end
  end 
   
     
  def self.open_spreadsheet(file) 
    case File.extname(file.original_filename) 
      when ".csv" then Roo::Csv.new(file.path)#, nil, :ignore) 
      when ".xls" then Roo::Excel.new(file.path)#, nil, :ignore) 
      when ".xlsx" then Roo::Excelx.new(file.path)#, nil, :ignore) 
      else raise "Unknown file type: #{file.original_filename}" 
    end
  end
  
  def valid_unique_record
    if issue_date
      exist_unitfuel=DepotFuel.where('unit_id=? and issue_date >=? and issue_date <=?', unit_id, issue_date.beginning_of_month, issue_date.end_of_month)
      if exist_unitfuel && exist_unitfuel.count > 0
        time_created=exist_unitfuel.first.created_at
        if (time_created!=created_at || created_at==nil) #created_at only exist for saved records
          errors.add(:base, 'Record already exist. Only 1 record of Depot Fuel allowed for each Depot in a month.')
        end
      end
    end
  end
  
  def issue_date_not_later_today
    if issue_date && issue_date > Date.today 
      errors.add(:base, 'Issue Date should not later than today.')
    end
  end
  
  def self.search_by_role(is_admin, staffid)
    if is_admin== "1"
      DepotFuel.all 
    else
      curr_staff=Staff.find(staffid)
      DepotFuel.where(unit_id: curr_staff.unit_id) if curr_staff && curr_staff.unit_id
    end
  end

  #Below - used for REAL TIME notification, whereas those in Fuel Limit used for DISPLAY purpose for all notification throughout the budget year
  def diesel_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id)
  end
  
  def petrol_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id)
  end
  
  def avtur_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id)
  end
  
  def avcat_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id)
  end
  
  def diesel_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id).first
  end
  
  def petrol_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id).first
  end
  
  def avtur_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id).first
  end
  
  def avcat_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id).first
  end
  
  def usages(limit, budgets)
    if budgets.count > 0
      budget_start_date=budgets.order(year_starts_on: :desc).last.year_starts_on
      if limit
        days_diff = (Date.today-budget_start_date.to_date).to_i
        days_no = days_diff  % (limit.duration-1)  #days_diff  % limit.duration
#         limit_set = days_diff / limit.duration
        if days_no == 0 && days_diff > 0
#           if limit_set==0
#             limitstart=Date.today-days_diff
#           else
#             limitstart=Date.today-(days_diff*limit_set)
#           end
          limitstart=Date.today-limit.duration
          usages_rec=FuelIssued.joins(:depot_fuel).where('depot_fuels.unit_id=?', limit.unit_id).where('depot_fuels.issue_date >=? and depot_fuels. issue_date <=?', limitstart, Date.today).where(fuel_type: limit.fuel_type)
         end
      end
    end
    usages_rec
  end
  
  def usage_amount(limit, budgets)
    usages(limit, budgets).sum(:quantity)
  end
  
  def surplus_amount(limit, budgets)
    if limit && usages(limit, budgets)
      if usages(limit, budgets).first.unit_type==limit.limit_unit_type 
        if usage_amount(limit, budgets) > limit.limit_amount
          surplus= usage_amount(limit, budgets) - limit.limit_amount
        else
          surplus=0
        end
      else
        surplus=0
      end
    else
      surplus=0
    end
    surplus
  end
  
end

# == Schema Information
#
# Table name: depot_fuels
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  issue_date :date
#  unit_id    :integer
#  updated_at :datetime
#
