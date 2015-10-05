class FuelBudgetsController < ApplicationController
  filter_access_to :all, :except => [:annual_budget, :budget_vs_usage, :budget_vs_usage_list]
  before_action :set_fuel_budget, only: [:show, :edit, :update, :destroy]

  # GET /fuel_budgets
  # GET /fuel_budgets.json
  def index
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || current_user.staff_id
      @search = FuelBudget.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @fuel_budgets= @search.result
    end
    respond_to do |format|
      if is_admin=="1" || current_user.staff_id
        format.html
      else
        format.html {redirect_to root_path, notice: (t 'users.staff_required')}
      end
    end
  end

  # GET /fuel_budgets/1
  # GET /fuel_budgets/1.json
  def show
  end

  # GET /fuel_budgets/new
  def new
    @fuel_budget = FuelBudget.new
  end

  # GET /fuel_budgets/1/edit
  def edit
  end

  # POST /fuel_budgets
  # POST /fuel_budgets.json
  def create
    @fuel_budget = FuelBudget.new(fuel_budget_params)

    respond_to do |format|
      if @fuel_budget.save
        format.html { redirect_to @fuel_budget, notice: 'Fuel budget was successfully created.' }
        format.json { render :show, status: :created, location: @fuel_budget }
      else
        format.html { render :new }
        format.json { render json: @fuel_budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_budgets/1
  # PATCH/PUT /fuel_budgets/1.json
  def update
    respond_to do |format|
      if @fuel_budget.update(fuel_budget_params)
        format.html { redirect_to @fuel_budget, notice: 'Fuel budget was successfully updated.' }
        format.json { render :show, status: :ok, location: @fuel_budget }
      else
        format.html { render :edit }
        format.json { render json: @fuel_budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_budgets/1
  # DELETE /fuel_budgets/1.json
  def destroy
    @fuel_budget.destroy
    respond_to do |format|
      format.html { redirect_to fuel_budgets_url, notice: 'Fuel budget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def annual_budget
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_year.strftime('%Y-%m-%d')
      @end_on = Date.parse((params[:search][:start_date])).end_of_year.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_year).strftime('%Y-%m-%d')
      @end_on = (Date.today.end_of_year).strftime('%Y-%m-%d')
    end
    @fuel_budgets=FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on)
  end
  
  def budget_vs_usage_list
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_year.strftime('%Y-%m-%d')
      @end_on = Date.parse((params[:search][:start_date])).end_of_year.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_year).strftime('%Y-%m-%d')
      @end_on = (Date.today.end_of_year).strftime('%Y-%m-%d')
    end
    @depot_fuels=DepotFuel.all
    @depot_fuels2=@depot_fuels.where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    @budget=FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on)
    depot_budget=@budget.where(unit_id: FuelTank.pluck(:unit_id))
    @depot_budget_diesel=depot_budget.where(fuel_type: (FuelType.where(name: 'DIESEL')))
    @depot_budget_petrol=depot_budget.where(fuel_type: (FuelType.where(name: 'PETROL')))
    @depot_budget_avtur=depot_budget.where(fuel_type: (FuelType.where(name: 'AVTUR')))
    @depot_budget_avcat=depot_budget.where(fuel_type: (FuelType.where(name: 'AVCAT')))
    unit_budget=@budget.where.not(unit_id: FuelTank.pluck(:unit_id))
    @budget_diesel=unit_budget.where(fuel_type: (FuelType.where(name: 'DIESEL')))
    @budget_petrol=unit_budget.where(fuel_type: (FuelType.where(name: 'PETROL')))
    @budget_avtur=unit_budget.where(fuel_type: (FuelType.where(name: 'AVTUR')))
    @budget_avcat=unit_budget.where(fuel_type: (FuelType.where(name: 'AVCAT')))
    @fuel_issueds=FuelIssued.joins(:depot_fuel).where('depot_fuels.issue_date >=? and depot_fuels.issue_date <=?', @start_from, @end_on)
    
    if @fuel_issueds.count > 0    
    #unless @fuel_issueds.count > 0
      @unit_fuels=UnitFuel.where.not(unit_id: FuelTank.pluck(:unit_id))
      @d_unit_fuels=UnitFuel.where(unit_id: FuelTank.pluck(:unit_id)).where('issue_date >=? and issue_date <=?', @start_from, @end_on)   
      @diesel_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'DIESEL'))
      @petrol_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'PETROL'))
      @avtur_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'AVTUR'))
      @avcat_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'AVCAT'))
    else ###
      diesel_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'DIESEL'))))
      petrol_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'PETROL'))))
      avtur_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVTUR'))))
      avcat_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVCAT'))))
      @all_diesel_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'DIESEL'))).pluck(:unit_id))
      @all_petrol_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'PETROL'))).pluck(:unit_id))
      @all_avtur_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVTUR'))).pluck(:unit_id))
      @all_avcat_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVCAT'))).pluck(:unit_id))

      #####----------Usage Breakdown by Depot--start
      @sub_diesel_usage=[]
      @sub_petrol_usage=[]
      @sub_avtur_usage=[]
      @sub_avcat_usage=[]
 
      diesel_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, dieselusages|
        diesel_usages_vehicles=diesel_usages.where(id: dieselusages.map(&:id)).where(is_vehicle: true)
        diesel_vehicle_ids=diesel_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_diesel_usage=[]
        VehicleAssignment.all.each do |vas|   
          vehicles_own= vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=diesel_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_diesel_usage << [vas.unit_receiver, usages_own.sum(:amount)] if (vehicles_own & diesel_vehicle_ids !=[]) && diesel_vehicle_ids.count > 0
        end
        diesel_usages.where(id: dieselusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_diesel_usage << [unit_vessel, usage.sum(&:amount)]
        end
        @sub_diesel_usage << [depot, sub_diesel_usage]
      end
      
      petrol_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, petrolusages|
        petrol_usages_vehicles=petrol_usages.where(id: petrolusages.map(&:id)).where(is_vehicle: true)
        petrol_vehicle_ids=petrol_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_petrol_usage=[]
        VehicleAssignment.all.each do |vas|
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=petrol_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_petrol_usage << [vas.unit_receiver, usages_own.sum(:amount)]  if (vehicles_own & petrol_vehicle_ids !=[]) && petrol_vehicle_ids.count > 0
        end
        petrol_usages.where(id: petrolusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_petrol_usage << [unit_vessel, usage.sum(&:amount)]
        end
        @sub_petrol_usage << [depot, sub_petrol_usage]
      end

      avtur_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, avturusages|
        avtur_usages_vehicles=avtur_usages.where(id: avturusages.map(&:id)).where(is_vehicle: true)
        avtur_vehicle_ids=avtur_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_avtur_usage=[]
        VehicleAssignment.all.each do |vas|
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=avtur_usages_vehicles.where(vehicle_id: vehicles_own).
          sub_avtur_usage <<  [vas.unit_receiver, usages_own.sum(:amount)]  if (vehicles_own & avtur_vehicle_ids !=[]) && avtur_vehicle_ids.count > 0
        end
        avtur_usages.where(id: avturusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_avtur_usage << [unit_vessel, usage.sum(&:amount)]
        end
        @sub_avtur_usage << [depot, sub_avtur_usage]
      end

      avcat_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, avcatusages|
        avcat_usages_vehicles=avcat_usages.where(id: avcatusages.map(&:id)).where(is_vehicle: true)
        avcat_vehicle_ids=avcat_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_avcat_usage=[]
        VehicleAssignment.all.each do |vas|   
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=avcat_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_avcat_usage << [vas.unit_receiver, usages_own.sum(:amount)] if (vehicles_own & avcat_vehicle_ids !=[]) && avcat_vehicle_ids.count > 0
        end
        avcat_usages.where(id: avcatusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_avcat_usage << [unit_vessel, usage.sum(&:amount)]
        end
        @sub_avcat_usage << [depot, sub_avcat_usage]
      end
      #####----------Usage Breakdown by Depot---end
      ###-------------Unit Budget Vs Usage ---start
      @sub_diesel_usage2=[]
      @sub_petrol_usage2=[]
      @sub_avtur_usage2=[]
      @sub_avcat_usage2=[]
      @diesel_usage2=Hash.new
      @petrol_usage2=Hash.new
      @avtur_usage2=Hash.new
      @avcat_usage2=Hash.new
      diesel_veh_ids=diesel_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      petrol_veh_ids=petrol_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      avtur_veh_ids=avtur_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      avcat_veh_ids=avcat_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      VehicleAssignment.all.each do |vas|   
        vehicles_own= vas.vehicle_assignment_details.pluck(:vehicle_id).compact.uniq
        d_usages_own=diesel_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        p_usages_own=petrol_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        avt_usages_own=avtur_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        avc_usages_own=avcat_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
#         @sub_diesel_usage2 << [vas.unit_receiver, d_usages_own.sum(:amount)] if (vehicles_own & diesel_veh_ids !=[] ) && diesel_veh_ids.count > 0
#         @sub_petrol_usage2 << [vas.unit_receiver, p_usages_own.sum(:amount)] if (vehicles_own & petrol_veh_ids !=[] ) && petrol_veh_ids.count > 0
#         @sub_avtur_usage2 << [vas.unit_receiver, avt_usages_own.sum(:amount)] if (vehicles_own & avtur_veh_ids !=[] ) && avtur_veh_ids.count > 0
#         @sub_avcat_usage2 << [vas.unit_receiver, avc_usages_own.sum(:amount)] if (vehicles_own & avcat_veh_ids !=[] ) && avcat_veh_ids.count > 0
        @sub_diesel_usage2 << [vas.unit_receiver, d_usages_own.sum(:amount)] if (vehicles_own & diesel_veh_ids !=[] ) && diesel_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @diesel_usage2[vas.unit_receiver.name] = d_usages_own.sum(:amount) if (vehicles_own & diesel_veh_ids !=[] ) && diesel_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_petrol_usage2 << [vas.unit_receiver, p_usages_own.sum(:amount)] if (vehicles_own & petrol_veh_ids !=[] ) && petrol_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @petrol_usage2[vas.unit_receiver.name] = p_usages_own.sum(:amount) if (vehicles_own & petrol_veh_ids !=[] ) && petrol_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_avtur_usage2 << [vas.unit_receiver, avt_usages_own.sum(:amount)] if (vehicles_own & avtur_veh_ids !=[] ) && avtur_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @avtur_usage2[vas.unit_receiver.name] = avt_usages_own.sum(:amount) if (vehicles_own & avtur_veh_ids !=[] ) && avtur_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_avcat_usage2 << [vas.unit_receiver, avc_usages_own.sum(:amount)] if (vehicles_own & avcat_veh_ids !=[] ) && avcat_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @avcat_usage2[vas.unit_receiver.name] = avc_usages_own.sum(:amount) if (vehicles_own & avcat_veh_ids !=[] ) && avcat_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true 
      end
      diesel_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_diesel_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      petrol_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_petrol_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      avtur_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_avtur_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      avcat_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_avcat_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      ###-------------Unit Budget Vs Usage ---end
    end
  end
  
  def budget_vs_usage
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_year.strftime('%Y-%m-%d')
      @end_on = Date.parse((params[:search][:start_date])).end_of_year.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_year).strftime('%Y-%m-%d')
      @end_on = (Date.today.end_of_year).strftime('%Y-%m-%d')
    end
    
    #BUDGET section ----
    @budget=FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on).where.not(unit_id: FuelTank.pluck(:unit_id))
    @diesel_budget=Hash.new
    @budget.where(fuel_type: (FuelType.where(name: 'DIESEL'))).group_by(&:unit).each do |unit, budgets|
      @diesel_budget[unit.name]=budgets.last.amount
    end
    @petrol_budget=Hash.new
    @budget.where(fuel_type: (FuelType.where(name: 'PETROL'))).group_by(&:unit).each do |unit, budgets|
      @petrol_budget[unit.name]=budgets.last.amount
    end
    @avtur_budget=Hash.new
    @budget.where(fuel_type: (FuelType.where(name: 'AVTUR'))).group_by(&:unit).each do |unit, budgets|
      @avtur_budget[unit.name]=budgets.last.amount
    end
    @avcat_budget=Hash.new
    @budget.where(fuel_type: (FuelType.where(name: 'AVCAT'))).group_by(&:unit).each do |unit, budgets|
      @avcat_budget[unit.name]=budgets.last.amount
    end
    
    #Depot level - source:Depot Fuel
    main_budget = FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on).where(unit_id: FuelTank.pluck(:unit_id))
    @main_diesel_budget = main_budget.where(fuel_type: (FuelType.where(name: 'DIESEL'))).group(:unit).sum(:amount)
    @main_petrol_budget = main_budget.where(fuel_type: (FuelType.where(name: 'PETROL'))).group(:unit).sum(:amount)
    @main_avtur_budget = main_budget.where(fuel_type: (FuelType.where(name: 'AVTUR'))).group(:unit).sum(:amount)
    @main_avcat_budget = main_budget.where(fuel_type: (FuelType.where(name: 'AVCAT'))).group(:unit).sum(:amount)
    depot_fuels = DepotFuel.where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    @fuel_issueds=FuelIssued.joins(:depot_fuel).where('depot_fuels.issue_date >=? and depot_fuels.issue_date <=?', @start_from, @end_on)
    @main_diesel_usage=Hash.new
    @main_petrol_usage=Hash.new
    @main_avtur_usage=Hash.new
    @main_avcat_usage=Hash.new
    @sub_diesel_usage=[]
    @sub_petrol_usage=[]
    @sub_avtur_usage=[]
    @sub_avcat_usage=[]
    @depot_ids=[]
  
    #************************
    if @fuel_issueds.count > 0    
    #unless @fuel_issueds.count > 0
      depot_fuels.group_by(&:unit_id).each do |depot_id, depot_fuels2|
          fuel_issueds=FuelIssued.where(depot_fuel_id: depot_fuels2.map(&:id))
          diesel_issueds=fuel_issueds.where(fuel_type: (FuelType.where(name: 'DIESEL')))
          petrol_issueds=fuel_issueds.where(fuel_type: (FuelType.where(name: 'PETROL')))
          avtur_issueds=fuel_issueds.where(fuel_type: (FuelType.where(name: 'AVTUR')))
          avcat_issueds=fuel_issueds.where(fuel_type: (FuelType.where(name: 'AVCAT')))
          @main_diesel_usage[Unit.where(id: depot_id).first.name]=diesel_issueds.sum(:quantity)
          @main_petrol_usage[Unit.where(id: depot_id).first.name]=petrol_issueds.sum(:quantity)
          @main_avtur_usage[Unit.where(id: depot_id).first.name]=avtur_issueds.sum(:quantity)
          @main_avcat_usage[Unit.where(id: depot_id).first.name]=avcat_issueds.sum(:quantity)
          @sub_diesel_usage << diesel_issueds.group(:receiver).sum(:quantity)
          @sub_petrol_usage << petrol_issueds.group(:receiver).sum(:quantity)
          @sub_avtur_usage << avtur_issueds.group(:receiver).sum(:quantity)
          @sub_avcat_usage << avcat_issueds.group(:receiver).sum(:quantity)
          @sub_diesel_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'DIESEL'))).group(:receiver).sum(:quantity)
          @sub_petrol_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'PETROL'))).group(:receiver).sum(:quantity)
          @sub_avtur_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'AVTUR'))).group(:receiver).sum(:quantity)
          @sub_avcat_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'AVCAT'))).group(:receiver).sum(:quantity)
          @depot_ids << depot_id
      end
      #USAGE section --- Unit Fuel only - start
      @unit_fuels=UnitFuel.where.not(unit_id: FuelTank.pluck(:unit_id)).sort_by{|x|x.unit.name}
      @d_unit_fuels=UnitFuel.where(unit_id: FuelTank.pluck(:unit_id)).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sort_by{|x|x.unit.name}
      @diesel_usage=Hash.new
      @diesel_usage2=Hash.new
      @petrol_usage=Hash.new
      @petrol_usage2=Hash.new
      @avtur_usage=Hash.new
      @avtur_usage2=Hash.new
      @avcat_usage=Hash.new
      @avcat_usage2=Hash.new
      #retrieve ALL Diesel & Petrol usage (within selected budget year) for each unit
      @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=@budget.where(fuel_type: (FuelType.where(name: 'DIESEL'))).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', budget_startdate, budget_enddate)
        else
          #retrieve all usage within sel    ected year if budget not exist
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on)
        end
        @diesel_usage[unit.name]=unitfuels2.sum(:d_vessel)+unitfuels2.sum(:d_vehicle)+unitfuels2.sum(:d_misctool)+unitfuels2.sum(:d_boat)
      end
      @d_unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        @diesel_usage2[unit.name]=unitfuels.sum(&:d_vessel)+unitfuels.sum(&:d_vehicle)+unitfuels.sum(&:d_misctool)+unitfuels.sum(&:d_boat)
      end
    
      @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=@budget.where(fuel_type_id: (FuelType.where(name: 'PETROL')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', budget_startdate, budget_enddate)
        else
          unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on)
        end
        @petrol_usage[unit.name]=unitfuels2.sum(:p_vehicle)+unitfuels2.sum(:p_misctool)+unitfuels2.sum(:p_boat)
      end
      @d_unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        @petrol_usage2[unit.name]=unitfuels.sum(&:p_vehicle)+unitfuels.sum(&:p_misctool)+unitfuels.sum(&:p_boat)
      end
    
      #retrieve ALL AVTUR & AVCAT usage (within selected budget year) for each unit
      @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=@budget.where(fuel_type_id: (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id:   unit.id).where('issue_date >=? and issue_date<=?', budget_startdate, budget_enddate).sum(:quantity)
        else
          @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
        end
      end
      @d_unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        @avtur_usage2[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id:   unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
      end
    
      @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        budget_startdate=@budget.where(fuel_type_id: (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
        if budget_startdate
          if budget_startdate.to_date.year < Date.today.year
            budget_enddate=budget_startdate.to_date+364.days
          else
            budget_enddate=Date.today
          end
          @avcat_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', budget_startdate, budget_enddate).sum(:quantity)
        else
          @avcat_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
        end
      end
      @d_unit_fuels.group_by(&:unit).each do |unit, unitfuels|
        @avcat_usage2[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id:   unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
      end
      #USAGE section --- Unit Fuel only -- end

    else ###
      diesel_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'DIESEL'))))
      petrol_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'PETROL'))))
      avtur_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVTUR'))))
      avcat_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVCAT'))))
      @all_diesel_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'DIESEL'))).pluck(:unit_id))
      @all_petrol_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'PETROL'))).pluck(:unit_id))
      @all_avtur_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVTUR'))).pluck(:unit_id))
      @all_avcat_depots=Unit.where(id: FuelTank.where(fuel_type: (FuelType.where(name: 'AVCAT'))).pluck(:unit_id))
      
      #####----------Usage Breakdown by Depot--start
      diesel_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, dieselusages|
        diesel_usages_vehicles=diesel_usages.where(id: dieselusages.map(&:id)).where(is_vehicle: true)
        diesel_vehicle_ids=diesel_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_diesel_usage=[]
        VehicleAssignment.all.each do |vas|   
          vehicles_own= vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=diesel_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_diesel_usage << [vas.unit_receiver, usages_own.sum(:amount)] if (vehicles_own & diesel_vehicle_ids !=[]) && diesel_vehicle_ids.count > 0
        end
        diesel_usages.where(id: dieselusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_diesel_usage << [unit_vessel, usage.sum(&:amount)]
        end
        #@sub_diesel_usage << [depot, sub_diesel_usage]
        @sub_diesel_usage << sub_diesel_usage
        @main_diesel_usage[Unit.where(id: depot.id).first.name]=dieselusages.sum(&:amount)
        @depot_ids << depot.id
      end
      
      petrol_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, petrolusages|
        petrol_usages_vehicles=petrol_usages.where(id: petrolusages.map(&:id)).where(is_vehicle: true)
        petrol_vehicle_ids=petrol_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_petrol_usage=[]
        VehicleAssignment.all.each do |vas|
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=petrol_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_petrol_usage << [vas.unit_receiver, usages_own.sum(:amount)]  if (vehicles_own & petrol_vehicle_ids !=[]) && petrol_vehicle_ids.count > 0
        end
        petrol_usages.where(id: petrolusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_petrol_usage << [unit_vessel, usage.sum(&:amount)]
        end
        #@sub_petrol_usage << [depot, sub_petrol_usage]
        @sub_petrol_usage << sub_petrol_usage
        @main_petrol_usage[Unit.where(id: depot.id).first.name]=petrolusages.sum(&:amount)
        @depot_ids << depot.id
      end

      avtur_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, avturusages|
        avtur_usages_vehicles=avtur_usages.where(id: avturusages.map(&:id)).where(is_vehicle: true)
        avtur_vehicle_ids=avtur_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_avtur_usage=[]
        VehicleAssignment.all.each do |vas|
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=avtur_usages_vehicles.where(vehicle_id: vehicles_own).
          sub_avtur_usage <<  [vas.unit_receiver, usages_own.sum(:amount)]  if (vehicles_own & avtur_vehicle_ids !=[]) && avtur_vehicle_ids.count > 0
        end
        avtur_usages.where(id: avturusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_avtur_usage << [unit_vessel, usage.sum(&:amount)]
        end
        #@sub_avtur_usage << [depot, sub_avtur_usage]
        @sub_avtur_usage << sub_avtur_usage
        @main_avtur_usage[Unit.where(id: depot.id).first.name]=avturusages.sum(&:amount)
        @depot_ids << depot.id
      end

      avcat_usages.group_by{|x|x.fuel_tank.unit}.each do |depot, avcatusages|
        avcat_usages_vehicles=avcat_usages.where(id: avcatusages.map(&:id)).where(is_vehicle: true)
        avcat_vehicle_ids=avcat_usages_vehicles.pluck(:vehicle_id).compact.uniq
        sub_avcat_usage=[]
        VehicleAssignment.all.each do |vas|   
          vehicles_own=vas.vehicle_assignment_details.pluck(:vehicle_id)
          usages_own=avcat_usages_vehicles.where(vehicle_id: vehicles_own)
          sub_avcat_usage << [vas.unit_receiver, usages_own.sum(:amount)] if (vehicles_own & avcat_vehicle_ids !=[]) && avcat_vehicle_ids.count > 0
        end
        avcat_usages.where(id: avcatusages.map(&:id)).where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
          sub_avcat_usage << [unit_vessel, usage.sum(&:amount)]
        end
        #@sub_avcat_usage << [depot, sub_avcat_usage]
        @sub_avcat_usage << sub_avcat_usage
        @main_avcat_usage[Unit.where(id: depot.id).first.name]=avcatusages.sum(&:amount)
        @depot_ids << depot.id
      end
      @depot_ids=@depot_ids.compact.uniq
      #####----------Usage Breakdown by Depot---end
      
      ###-------------Unit Budget Vs Usage ---start
      @sub_diesel_usage2=[]
      @sub_petrol_usage2=[]
      @sub_avtur_usage2=[]
      @sub_avcat_usage2=[]
      @diesel_usage2=Hash.new
      @petrol_usage2=Hash.new
      @avtur_usage2=Hash.new
      @avcat_usage2=Hash.new
      diesel_veh_ids=diesel_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      petrol_veh_ids=petrol_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      avtur_veh_ids=avtur_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      avcat_veh_ids=avcat_usages.where(is_vehicle: true).pluck(:vehicle_id).compact.uniq
      VehicleAssignment.all.each do |vas|   
        vehicles_own= vas.vehicle_assignment_details.pluck(:vehicle_id).compact.uniq
        d_usages_own=diesel_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        p_usages_own=petrol_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        avt_usages_own=avtur_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        avc_usages_own=avcat_usages.where(is_vehicle: true).where(vehicle_id: vehicles_own)
        @sub_diesel_usage2 << [vas.unit_receiver, d_usages_own.sum(:amount)] if (vehicles_own & diesel_veh_ids !=[] ) && diesel_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @diesel_usage2[vas.unit_receiver.name] = d_usages_own.sum(:amount) if (vehicles_own & diesel_veh_ids !=[] ) && diesel_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_petrol_usage2 << [vas.unit_receiver, p_usages_own.sum(:amount)] if (vehicles_own & petrol_veh_ids !=[] ) && petrol_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @petrol_usage2[vas.unit_receiver.name] = p_usages_own.sum(:amount) if (vehicles_own & petrol_veh_ids !=[] ) && petrol_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_avtur_usage2 << [vas.unit_receiver, avt_usages_own.sum(:amount)] if (vehicles_own & avtur_veh_ids !=[] ) && avtur_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @avtur_usage2[vas.unit_receiver.name] = avt_usages_own.sum(:amount) if (vehicles_own & avtur_veh_ids !=[] ) && avtur_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
        @sub_avcat_usage2 << [vas.unit_receiver, avc_usages_own.sum(:amount)] if (vehicles_own & avcat_veh_ids !=[] ) && avcat_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==false
        @avcat_usage2[vas.unit_receiver.name] = avc_usages_own.sum(:amount) if (vehicles_own & avcat_veh_ids !=[] ) && avcat_veh_ids.count > 0 && FuelTank.pluck(:unit_id).include?(vas.unit_id)==true
      end
      diesel_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_diesel_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      petrol_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_petrol_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      avtur_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_avtur_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      avcat_usages.where(is_vehicle: false).group_by{|x|x.vessel.unit}.each do |unit_vessel, usage|
        @sub_avcat_usage2 << [unit_vessel, usage.sum(&:amount)]
      end
      ###-------------Unit Budget Vs Usage ---end
    end
    #***********************
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_budget
      @fuel_budget = FuelBudget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_budget_params
      params.require(:fuel_budget).permit(:parent_id, :code, :unit_id, :year_starts_on, :fuel_type_id, :amount, :unit_type_id)
    end
end
