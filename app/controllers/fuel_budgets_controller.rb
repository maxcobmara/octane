class FuelBudgetsController < ApplicationController
  before_action :set_fuel_budget, only: [:show, :edit, :update, :destroy]

  # GET /fuel_budgets
  # GET /fuel_budgets.json
  def index
    @search = FuelBudget.search(params[:q])
    @fuel_budgets  = @search.result
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
    @fuel_budgets=FuelBudget.all
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
    @budget=FuelBudget.where('year_starts_on >=? and year_starts_on<=?', @start_from, @end_on)
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
    @unit_fuels=UnitFuel.all
    @diesel_usage=Hash.new
    @petrol_usage=Hash.new
    @avtur_usage=Hash.new
    @avcat_usage=Hash.new
    
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
