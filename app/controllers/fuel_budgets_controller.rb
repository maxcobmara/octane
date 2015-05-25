class FuelBudgetsController < ApplicationController
  before_action :set_fuel_budget, only: [:show, :edit, :update, :destroy]

  # GET /fuel_budgets
  # GET /fuel_budgets.json
  def index
    @fuel_budgets = FuelBudget.all
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
