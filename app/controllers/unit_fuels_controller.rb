class UnitFuelsController < ApplicationController
  load_and_authorize_resource except: [:fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
  #filter_access_to :all, :except => [:fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
  before_action :set_unit_fuel, only: [:show, :edit, :update, :destroy]

  # GET /unit_fuels
  # GET /unit_fuels.json
  def index
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || current_user.staff.unit_id
      @search = UnitFuel.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @unit_fuels = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || current_user.staff.unit_id
        format.html
        format.csv { send_data @unit_fuels.to_csv }
        format.xls { send_data @unit_fuels.to_csv(col_sep: "\t") }
      else
        format.html {redirect_to root_path, notice: (t 'menu.unit_fuels')+(t 'users.staff_required')}
      end
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
        format.html { redirect_to @unit_fuel, notice: (t 'unit_fuels.title3')+(t 'actions.created') }
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
        format.html { redirect_to @unit_fuel, notice: (t 'unit_fuels.title3')+(t 'actions.updated') }
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
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_month.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_month-1.month).strftime('%Y-%m-%d')
    end
    if params[:search].present? && params[:search][:end_date].present?
      @end_on = Date.parse(params[:search][:end_date]).end_of_month.strftime('%Y-%m-%d')
    else
      @end_on = (Date.today.end_of_month).strftime('%Y-%m-%d')
    end
    @month_fuel_usage = UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on ) 
    @month_other_usage = AddFuel.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on ) 
    @month_avtur_usage = @month_other_usage.where(fuel_type: FuelType.where(name: 'AVTUR'))
    @month_avcat_usage = @month_other_usage.where(fuel_type: FuelType.where(name: 'AVCAT'))
    @month_lubricant_usage = @month_other_usage.where(fuel_type: FuelType.where(name: 'PELINCIR'))
    @month_grease_usage = @month_other_usage.where(fuel_type: FuelType.where(name: 'GRIS'))
    @month_other_usage = @month_other_usage.where.not(fuel_type: FuelType.where(name: 'AVCAT')).where.not(fuel_type: FuelType.where(name: 'AVTUR')).where.not(fuel_type: FuelType.where(name: 'PELINCIR')).where.not(fuel_type: FuelType.where(name: 'GRIS'))
    @month_external_supply=ExternalSupplied.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on ) 
    @month_external_supply_darat=@month_external_supply.where(resource: Unit.where(shortname: 'TD'))
    @month_external_supply_udara=@month_external_supply.where(resource: Unit.where(shortname: 'TUDM'))
    @month_external_issue=ExternalIssued.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on ) 
    @month_external_issue_darat=@month_external_issue.where(resource: Unit.where(shortname: 'TD'))
    @month_external_issue_udara=@month_external_issue.where(resource: Unit.where(shortname: 'TUDM'))
    @inden_usages=IndenUsage.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on)
  end
  
  def unit_fuel_list_usage  
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_day.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_month).strftime('%Y-%m-%d')
    end
    if params[:search].present? && params[:search][:end_date].present?
      @end_on = Date.parse(params[:search][:end_date]).end_of_day.strftime('%Y-%m-%d')
    else
      @end_on = (Date.today.end_of_day).strftime('%Y-%m-%d')
    end
    @summary=UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on) 
    @main_other_fuels=AddFuel.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on)
    @avtur=@main_other_fuels.where(fuel_type: FuelType.where('name LIKE (?)', 'AVTUR') )
    @avcat=@main_other_fuels.where(fuel_type: FuelType.where('name LIKE (?)', 'AVCAT') )
    @lubricant=@main_other_fuels.where(fuel_type: FuelType.where('name LIKE (?)', 'PELINCIR') )
    @grease=@main_other_fuels.where(fuel_type: FuelType.where('name LIKE (?)', 'GRIS') )
    @other_fuels= @main_other_fuels.where.not(id: @avtur.pluck(:id)+@avcat.pluck(:id)+@lubricant.pluck(:id)+@grease.pluck(:id))
    @external_supply=ExternalSupplied.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on)
    @external_issue=ExternalIssued.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on)
    @inden_usages=IndenUsage.joins(:unit_fuel).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on)
    @other_fuels_type=AddFuel.where.not(fuel_type: FuelType.where('name LIKE (?) or name ILIKE (?) or name ILIKE (?)or name ILIKE (?)', 'AVTUR', 'AVCAT', 'PELINCIR', 'GRIS')).pluck(:fuel_type_id).compact.uniq
    @sources=ExternalSupplied.all.sort_by{|x|x.resource.name}.reverse.map(&:source).compact.uniq
  end
  
  def fuel_type_usage_category
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_day.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_month).strftime('%Y-%m-%d')
    end
    if params[:search].present? && params[:search][:end_date].present?
      @end_on = Date.parse(params[:search][:end_date]).end_of_day.strftime('%Y-%m-%d')
    else
      @end_on = (Date.today.end_of_day).strftime('%Y-%m-%d')
    end
    ###
    #busses & cars - KD Malaya, KD Pelandok, KD Sultan Badlishah (bas - diesel, kereta - petrol), Conclusion: bas - d_vehicle, kereta - p_vehicle
    unit_ids_w_bus=Unit.where('name ILIKE(?) or name ILIKE(?) or name ILIKE(?)', '%malaya%', '%pelandok%', '%sultan badlishah%').pluck(:id)
    @bus_usage=UnitFuel.where(unit: unit_ids_w_bus).where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on).sum(:d_vehicle)
    #@car_usage_a=UnitFuel.where(unit: unit_ids_w_bus).sum(:p_vehicle)
    
    #cars only - other than above 3 units (kereta - petrol), Conclusion: kereta - p_vehicle
    #@car_usage_b=UnitFuel.where.not(unit: unit_ids_w_bus).sum(:p_vehicle)
    
    #@car_usage equal to @car_usage_a+@car_usage_b
    @car_usage=UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on).sum(:p_vehicle)

    #lories - Depoh Bekalan Armada, Depot Logistik Wilayah 1, Depot Logistik Wilayah 2, Depot Logistik Wilayah 3 (lori - diesel), Conclusion: lori - d_vehicle
    unit_ids_w_lorry=Unit.where('name ILIKE(?) or name ILIKE(?)', '%bekalan armada%', '%logistik wilayah%').pluck(:id)
    @lorry_usage=UnitFuel.where(unit: unit_ids_w_lorry).where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on).sum(:d_vehicle)
    
    #Option 1 : vessel - Units whereby vessel is a unit (Unit has one vessel) - better, only retrieve VALID vessel (vessel type, vessel class & vessel) - reporting by PENNENT NO
    vessel_ids=Vessel.pluck(:unit_id)
    @vessels=UnitFuel.where(unit_id: vessel_ids).where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on) 
    @vessel_usage=@vessels.sum(:d_vessel)
    #Option 2 : d_vessel - retrieve ALL, ignore VALID vessel
    #@vessel_usage=UnitFuel.where('d_vessel IS NOT NULL').sum(:d_vessel)
    
    #diesel usage - d_vessel, d_vehicle, d_misctool, d_boat
    #petrol usage - p_vehicle, p_misctool, p_boat
    
    ###p_vehicle - all considered as Cars
    ###d_vehicle (in KD Malaya, KD Pelandok, KD Sultan Badlishah - Busses)
    ###d_vehicle (in Depoh Bekalan Armada, Depot Logistik Wilayah 1, Depot Logistik Wilayah 2, Depot Logistik Wilayah 3 - Lorries)
    ###d_vehicle (in other Unit/department - ignored) - forklift?
    ###d_vessel (Vessels)
    
    @avcat=AddFuel.joins(:unit_fuel).where(fuel_type: FuelType.where(name: 'AVCAT')).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on) 
    @avcat_vessel=@avcat.where('unit_fuels.unit_id IN(?)', Vessel.pluck(:unit_id))
    @avcat_others=@avcat.where.not('unit_fuels.unit_id IN(?)', Vessel.pluck(:unit_id))
    @avcat_usage=@avcat.sum(:quantity) 
    
    @avtur=AddFuel.joins(:unit_fuel).where(fuel_type: FuelType.where(name: 'AVTUR')).where( "unit_fuels.issue_date >= ? AND unit_fuels.issue_date <= ? ", @start_from, @end_on) 
    @avtur_vessel=@avtur.where('unit_fuels.unit_id IN(?)', Vessel.pluck(:unit_id))
    @avtur_others=@avtur.where.not('unit_fuels.unit_id IN(?)', Vessel.pluck(:unit_id))
    @avtur_usage=@avtur.sum(:quantity) 
    
  end
  
  def annual_usage_report  
    if params[:search].present? && params[:search][:start_date].present?
      @start_from = Date.parse((params[:search][:start_date])).beginning_of_year.strftime('%Y-%m-%d')
      @end_on = Date.parse((params[:search][:start_date])).end_of_year.strftime('%Y-%m-%d')
    else
      @start_from = (Date.today.beginning_of_year).strftime('%Y-%m-%d')
      @end_on = (Date.today.end_of_year).strftime('%Y-%m-%d')
    end
    @unit_fuels = UnitFuel.where( "issue_date >= ? AND issue_date <= ? ", @start_from, @end_on )
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
      params.require(:unit_fuel).permit(:issue_date, :unit_id, :d_vessel, :d_vehicle, :d_misctool, :d_boat, :p_vehicle, :p_misctool, :p_boat, add_fuels_attributes: [:id, :fuel_type_id, :description, :quantity, :unit_type_id], external_issueds_attributes: [:id, :fuel_type_id, :quantity, :unit_type_id, :source], external_supplieds_attributes: [:id, :fuel_type_id, :quantity, :unit_type_id, :source], inden_usages_attributes: [:id, :petrol_ltr, :diesel_ltr, :inden_card_id])
    end
end
