class UnitFuelsController < ApplicationController
  before_action :set_unit_fuel, only: [:show, :edit, :update, :destroy]

  # GET /unit_fuels
  # GET /unit_fuels.json
  def index
    @unit_fuels = UnitFuel.all
    @search = UnitFuel.search(params[:q])
    @unit_fuels = @search.result
    respond_to do |format|
      format.html
      format.csv { send_data @unit_fuels.to_csv }
      format.xls { send_data @unit_fuels.to_csv(col_sep: "\t") }
    end
  end

  # GET /unit_fuels/1
  # GET /unit_fuels/1.json
  def show
  end

  # GET /unit_fuels/new
  def new
    @unit_fuel = UnitFuel.new
  end

  # GET /unit_fuels/1/edit
  def edit
  end

  # POST /unit_fuels
  # POST /unit_fuels.json
  def create
    @unit_fuel = UnitFuel.new(unit_fuel_params)

    respond_to do |format|
      if @unit_fuel.save
        format.html { redirect_to @unit_fuel, notice: (t 'unit_fuels.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @unit_fuel }
      else
        format.html { render action: 'new' }
        format.json { render json: @unit_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unit_fuels/1
  # PATCH/PUT /unit_fuels/1.json
  def update
    respond_to do |format|
      if @unit_fuel.update(unit_fuel_params)
        format.html { redirect_to @unit_fuel, notice: (t 'unit_fuels.title')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unit_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_fuels/1
  # DELETE /unit_fuels/1.json
  def destroy
    @unit_fuel.destroy
    respond_to do |format|
      format.html { redirect_to unit_fuels_url }
      format.json { head :no_content }
    end
  end
  
  def unit_fuel_usage  
    c = Date.today
    sdate = c.beginning_of_month
    edate = c.end_of_month
    @sdate = c.beginning_of_month
    @edate = c.end_of_month
     @month_fuel_usage = UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", sdate, edate ) 
     @month_other_fuel = AddFuel.where( "created_at >= ? AND created_at <= ? ", sdate, edate )
     @month_external_supply = ExternalSupplied.where( "created_at >= ? AND created_at <= ? ", sdate, edate )
  end
  
  def annual_usage_report  
    c = Date.today
    @sdate = c.beginning_of_year
    @edate = c.end_of_year
     @year_annual_usage_report = UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @sdate, @edate ) 
     @year_other_fuel = AddFuel.where( "created_at >= ? AND created_at <= ? ", @sdate, @edate )
     @year_external_supply = ExternalSupplied.where( "created_at >= ? AND created_at <= ? ", @sdate, @edate )
     @unit_fuels = UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @sdate, @edate )
     @add_fuels = AddFuel.where( "issue_date >= ? AND issue_date <= ? ", @sdate, @edate )
  end
  
  def daily_usage  
    sdate = Date.today
     @daily_annual_usage_report = UnitFuel.where( "issue_date = ? ", sdate ) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_fuel
      @unit_fuel = UnitFuel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_fuel_params
      params.require(:unit_fuel).permit(:issue_date, :unit_id, :d_vessel, :d_vehicle, :d_misctool, :d_boat, :p_vehicle, :p_misctool, :p_boat, add_fuels_attributes: [:id, :fuel_type_id, :description, :quantity, :unit_type_id], external_issueds_attributes: [:id, :fuel_type_id, :quantity, :unit_type_id, :source], external_supplieds_attributes: [:id, :fuel_type_id, :quantity, :unit_type_id, :source])
    end
end
