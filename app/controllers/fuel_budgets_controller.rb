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
    #BUDGET section ----
    @budget=FuelBudget.all 
    #@diesel_budget = @budget.where(fuel_type: (FuelType.where(name: 'DIESEL'))).group(:unit).sum(:amount)
    #@petrol_budget = @budget.where(fuel_type: (FuelType.where(name: 'PETROL'))).group(:unit).sum(:amount)
    #@avtur_budget = @budget.where(fuel_type: (FuelType.where(name: 'AVTUR'))).group(:unit).sum(:amount)
    #@avcat_budget = @budget.where(fuel_type: (FuelType.where(name: 'AVCAT'))).group(:unit).sum(:amount)
    
    #retrieve LAST inserted item of budget for each UNIT (dept)
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
    
    #retrieve ALL Diesel usage ranging from the 1st day of LAST inserted budget for each unit
    @diesel_usage=Hash.new
    @petrol_usage=Hash.new
    @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
      budget_startdate=FuelBudget.where(fuel_type_id: (FuelType.where(name: 'DIESEL')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
      if budget_startdate
        unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=?', budget_startdate)
      else
        unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=?', Date.today.beginning_of_year)
      end
      @diesel_usage[unit.name]=unitfuels2.sum(:d_vessel)+unitfuels2.sum(:d_vehicle)+unitfuels2.sum(:d_misctool)+unitfuels2.sum(:d_boat)
    end
    
    #retrieve ALL Petrol usage ranging from the 1st day of LAST inserted budget for each unit
    @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
      budget_startdate=FuelBudget.where(fuel_type_id: (FuelType.where(name: 'PETROL')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
      if budget_startdate
        unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=?', budget_startdate)
      else
        unitfuels2=UnitFuel.where(unit_id: unit.id).where('issue_date >=?', Date.today.beginning_of_year)
      end
      @petrol_usage[unit.name]=unitfuels2.sum(:p_vehicle)+unitfuels2.sum(:p_misctool)+unitfuels2.sum(:p_boat)
    end
    
    #@avtur_usage=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).group(:unit).sum(:quantity)
    #@avcat_usage=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).group(:unit).sum(:quantity)
    
    #retrieve ALL AVTUR usage ranging from the 1st day of LAST inserted budget for each unit
    @avtur_usage=Hash.new
    @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
      budget_startdate=FuelBudget.where(fuel_type_id: (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
      if budget_startdate
        @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=?', budget_startdate).sum(:quantity)
      else
        @avtur_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVTUR')).first.id).where(unit_id: unit.id).where('issue_date >=?', Date.today.beginning_of_year).sum(:quantity)
      end
    end
    
    #retrieve ALL AVCAT usage ranging from the 1st day of LAST inserted budget for each unit
    @avcat_usage=Hash.new
    @unit_fuels.group_by(&:unit).each do |unit, unitfuels|
      budget_startdate=FuelBudget.where(fuel_type_id: (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).last.try(:year_starts_on).try(:strftime, '%Y-%m-%d')
      if budget_startdate
        @avcat_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).where('issue_date >=?', budget_startdate).sum(:quantity)
      else
        @avcat_usage[unit.name]=UnitFuel.joins(:add_fuels).where('add_fuels.fuel_type_id=?', (FuelType.where(name: 'AVCAT')).first.id).where(unit_id: unit.id).where('issue_date >=?', Date.today.beginning_of_year).sum(:quantity)
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
