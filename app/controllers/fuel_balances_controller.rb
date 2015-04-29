class FuelBalancesController < ApplicationController
  before_action :set_fuel_balance, only: [:show, :edit, :update, :destroy]

  # GET /fuel_balances
  # GET /fuel_balances.json
  def index
    @fuel_balances = FuelBalance.all.order(:depot_fuel_id)
    @search = FuelBalance.search(params[:q])
    @fuel_balances = @search.result
  end

  # GET /fuel_balances/1
  # GET /fuel_balances/1.json
  def show
  end

  # GET /fuel_balances/new
  def new
    @depot_fuel = DepotFuel.find(params[:depot_fuel_id])
    @fuel_balance = @depot_fuel.fuel_balances.new(params[:fuel_balance])
    @fuel_balance.save
  end

  # GET /fuel_balances/1/edit
  def edit
  end

  # POST /fuel_balances
  # POST /fuel_balances.json
  def create
    @fuel_balance = FuelBalance.new(fuel_balance_params)

    respond_to do |format|
      if @fuel_balance.save
        format.html { redirect_to @fuel_balance, notice: (t 'fuel_balances.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @fuel_balance }
      else
        format.html { render action: 'new' }
        format.json { render json: @fuel_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_balances/1
  # PATCH/PUT /fuel_balances/1.json
  def update
    respond_to do |format|
      if @fuel_balance.update(fuel_balance_params)
        format.html { redirect_to @fuel_balance, notice: (t 'fuel_balances.title')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fuel_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_balances/1
  # DELETE /fuel_balances/1.json
  def destroy
    @fuel_balance.destroy
    respond_to do |format|
      format.html { redirect_to fuel_balances_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_balance
      @fuel_balance = FuelBalance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_balance_params
      params.require(:fuel_balance).permit(:depot_fuel_id, :fuel_tank_id, :current, :unit_type_id)
    end
end
