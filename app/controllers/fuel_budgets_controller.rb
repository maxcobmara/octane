class FuelBudgetsController < ApplicationController
  filter_access_to :all, :except => [:annual_budget, :budget_vs_usage, :budget_vs_usage_list]
  #filter_resource_access
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
    #@search = FuelBudget.search(params[:q])
    #@fuel_budgets  = @search.result
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
    @unit_fuels=UnitFuel.where.not(unit_id: FuelTank.pluck(:unit_id))
    @d_unit_fuels=UnitFuel.where(unit_id: FuelTank.pluck(:unit_id)).where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    @depot_fuels=DepotFuel.all
    @depot_fuels2=@depot_fuels.where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    budget=FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on)
    unit_budget=budget.where.not(unit_id: FuelTank.pluck(:unit_id))
    @budget_diesel=unit_budget.where(fuel_type: (FuelType.where(name: 'DIESEL')))
    @budget_petrol=unit_budget.where(fuel_type: (FuelType.where(name: 'PETROL')))
    @budget_avtur=unit_budget.where(fuel_type: (FuelType.where(name: 'AVTUR')))
    @budget_avcat=unit_budget.where(fuel_type: (FuelType.where(name: 'AVCAT')))
    depot_budget=budget.where(unit_id: FuelTank.pluck(:unit_id))
    @depot_budget_diesel=depot_budget.where(fuel_type: (FuelType.where(name: 'DIESEL')))
    @depot_budget_petrol=depot_budget.where(fuel_type: (FuelType.where(name: 'PETROL')))
    @depot_budget_avtur=depot_budget.where(fuel_type: (FuelType.where(name: 'AVTUR')))
    @depot_budget_avcat=depot_budget.where(fuel_type: (FuelType.where(name: 'AVCAT')))
    @fuel_issueds=FuelIssued.joins(:depot_fuel).where('depot_fuels.issue_date >=? and depot_fuels.issue_date <=?', @start_from, @end_on)
    @diesel_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'DIESEL'))
    @petrol_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'PETROL'))
    @avtur_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'AVTUR'))
    @avcat_issueds=@fuel_issueds.where(fuel_type: FuelType.where(name: 'AVCAT'))
  end
  
  def budget_vs_usage
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_year.strftime('%Y-%m-%d')
      @end_on = Date.parse((params[:search][:start_date])).end_of_year.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_year).strftime('%Y-%m-%d')
      @end_on = (Date.today.end_of_year).strftime('%Y-%m-%d')
    end
    
    #Depot level - source:Depot Fuel
    main_budget = FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on).where(unit_id: FuelTank.pluck(:unit_id))
    @main_diesel_budget = main_budget.where(fuel_type: (FuelType.where(name: 'DIESEL'))).group(:unit).sum(:amount)
    @main_petrol_budget = main_budget.where(fuel_type: (FuelType.where(name: 'PETROL'))).group(:unit).sum(:amount)
    @main_avtur_budget = main_budget.where(fuel_type: (FuelType.where(name: 'AVTUR'))).group(:unit).sum(:amount)
    @main_avcat_budget = main_budget.where(fuel_type: (FuelType.where(name: 'AVCAT'))).group(:unit).sum(:amount)
    depot_fuels = DepotFuel.where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    @main_diesel_usage=Hash.new
    @main_petrol_usage=Hash.new
    @main_avtur_usage=Hash.new
    @main_avcat_usage=Hash.new
    @sub_diesel_usage=[]
    @sub_petrol_usage=[]
    @sub_avtur_usage=[]
    @sub_avcat_usage=[]
    @depot_ids=[]
    depot_fuels.group_by(&:unit_id).each do |depot_id, depot_fuels2|
      fuel_issueds=FuelIssued.where(depot_fuel_id: depot_fuels2.map(&:id))
      if fuel_issueds.count > 0
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
      else
        diesel_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(unit_id: depot_id, fuel_type: (FuelType.where(name: 'DIESEL'))).pluck(:id))
        petrol_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(unit_id: depot_id, fuel_type: (FuelType.where(name: 'PETROL'))).pluck(:id))
        avtur_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(unit_id: depot_id, fuel_type: (FuelType.where(name: 'AVTUR'))).pluck(:id))
        avcat_usages=FuelTransaction.where(transaction_type: 'Usage').where(fuel_tank_id: FuelTank.where(unit_id: depot_id, fuel_type: (FuelType.where(name: 'AVCAT'))).pluck(:id))
        @main_diesel_usage[Unit.where(id: depot_id).first.name]=diesel_usages.sum(:amount)
        @main_petrol_usage[Unit.where(id: depot_id).first.name]=petrol_usages.sum(:amount)
        @main_avtur_usage[Unit.where(id: depot_id).first.name]=avtur_usages.sum(:amount)
        @main_avcat_usage[Unit.where(id: depot_id).first.name]=avcat_usages.sum(:amount)
      end
      @depot_ids << depot_id
    end
    @sub_diesel_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'DIESEL'))).group(:receiver).sum(:quantity)
    @sub_petrol_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'PETROL'))).group(:receiver).sum(:quantity)
    @sub_avtur_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'AVTUR'))).group(:receiver).sum(:quantity)
    @sub_avcat_usage2=FuelIssued.where(depot_fuel_id: depot_fuels.map(&:id)).where(fuel_type: (FuelType.where(name: 'AVCAT'))).group(:receiver).sum(:quantity)
    
    
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
    
    #USAGE section ---
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
        #retrieve all usage within selected year if budget not exist
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
        @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date<=?', budget_startdate, budget_enddate).sum(:quantity)
      else
        @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
      end
    end
    @d_unit_fuels.group_by(&:unit).each do |unit, unitfuels|
      @avtur_usage2[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
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
      @avcat_usage2[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).where('issue_date >=? and issue_date <=?', @start_from, @end_on).sum(:quantity)
    end

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
