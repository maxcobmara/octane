class DepotFuelsController < ApplicationController
  before_filter :set_depot_fuel, :only => [:show, :edit, :update, :destroy]
  
  load_and_authorize_resource
  #filter_access_to :index, :create, :import_excel, :attribute_check => false
  #filter_access_to :show, :edit, :update, :destroy, :attribute_check => true.  e.g. DepotFuel.accessible_by(current_ability)
  
  # GET /depot_fuels
  # GET /depot_fuels.json
  def index
    # HACK - refer header - avoid Unit user, using direct url
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
      @search = DepotFuel.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @depot_fuels = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
        format.html
      else
        format.html {redirect_to root_path, notice: (t 'menu.depot_fuels')+(t 'users.depot_staff_required')}
      end
    end
  end

  # GET /depot_fuels/1
  # GET /depot_fuels/1.json
  def show
  end

  # GET /depot_fuels/new
  def new
    # HACK - refer header - avoid Unit user, using direct url
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
      @depot_fuel = DepotFuel.new
    end
    respond_to do |format|
      if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
        format.html
      else
        format.html {redirect_to root_path, notice: (t 'menu.depot_fuels')+(t 'users.depot_staff_required')}
      end
    end
  end

  # GET /depot_fuels/1/edit
  def edit
  end

  # POST /depot_fuels
  # POST /depot_fuels.json
  def create
    @depot_fuel = DepotFuel.new(depot_fuel_params)

    respond_to do |format|
      if @depot_fuel.save
        @depot_fuel.surplus_notification
        format.html { redirect_to @depot_fuel, notice:  (t 'depot_fuels.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @depot_fuel }
      else
        format.html { render action: 'new' }
        format.json { render json: @depot_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /depot_fuels/1
  # PATCH/PUT /depot_fuels/1.json
  def update
    respond_to do |format|
      if @depot_fuel.update(depot_fuel_params)
        @depot_fuel.surplus_notification
        format.html { redirect_to @depot_fuel, notice:  (t 'depot_fuels.title')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @depot_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /depot_fuels/1
  # DELETE /depot_fuels/1.json
  def destroy
    @depot_fuel.destroy
    respond_to do |format|
      format.html { redirect_to depot_fuels_url }
      format.json { head :no_content }
    end
  end
  
  def depot_monthly_usage 
    @depot_fuels=DepotFuel.all
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
    @monthly_usage =DepotFuel.where('issue_date >=? and issue_date <=?', @start_from, @end_on)
    #@last_prev_depot_fuel = DepotFuel.where( "issue_date < ? ", @start_from).last
  end
  
  def import_excel
  end
  
  def import
    unless params[:file].nil?
	a=DepotFuel.import(params[:file]) 		#errorneous : "stc" " tn" " cap" " ftcm"
	if a == "stc"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')# "stc"
	elsif a == " tn"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.tn')#"tn"
	#elsif a == " cap"
	#	redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.cap')#"cap"
	elsif a == " ftcm"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.ftcm')#"ftcm"
	elsif a == "stc tn"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')+(t 'depot_fuels.tn')#"stc"+"tn"
	elsif a == "stc tn"# cap"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')+(t 'depot_fuels.tn')#+(t 'depot_fuels.cap')#"stc"+"tn"+"cap"
	elsif a == "stc tn ftcm"# cap ftcm"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')+(t 'depot_fuels.tn')+(t 'depot_fuels.ftcm')#+(t 'depot_fuels.cap') #"stc"+"tn"+"cap"+"ftcm"
	elsif a == "stc"# cap"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')#+(t 'depot_fuels.cap')# "stc"+"cap"
	elsif a == "stc ftcm"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')+(t 'depot_fuels.ftcm')#"stc"+"ftcm"
	elsif a == "stc ftcm"# cap ftcm"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.stc')+(t 'depot_fuels.ftcm')#+(t 'depot_fuels.cap') #"stc"+"cap"+"ftcm"
	elsif a == "tn"# cap"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.tn')#+(t 'depot_fuels.cap')# "tn"+"cap"
	elsif a == "tn ftcm"
		redirect_to import_excel_depot_fuel_url, notice: (t 'depot_fuels.failed')+(t 'depot_fuels.tn')+(t 'depot_fuels.ftcm')#"tn"+"ftcm"
	elsif a == "ftcm"#"cap ftcm"
		redirect_to import_excel_depot_fuel_url, notice:  (t 'depot_fuels.failed')+(t 'depot_fuels.ftcm')#+(t 'depot_fuels.cap')#"cap"+"ftcm"
	elsif a == "depot_not_exist"
		redirect_to import_excel_depot_fuel_url, notice:  (t 'depot_fuels.failed')+(t 'depot_fuels.depot_not_exist')
	else
		redirect_to depot_fuels_url, notice:(t 'depot_fuels.imported')
	end 
    else
      redirect_to import_excel_depot_fuel_url, notice: "Please select an Excel file for import."
    end
  end
  
  def download_excel_format
    send_file ("#{::Rails.root.to_s}/public/excel_format/DepotFuel_Excel.xls")
  end 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_depot_fuel
      @depot_fuel = DepotFuel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def depot_fuel_params
      params.require(:depot_fuel).permit(:unit_id, :issue_date, fuel_issueds_attributes: [:id, :depot_fuel_id, :fuel_type_id, :quantity, :unit_type_id, :unit_id, :_destroy], fuel_supplieds_attributes: [:id, :depot_fuel_id, :fuel_type_id, :quantity, :unit_type_id,:_destroy], fuel_balances_attributes: [:id, :depot_fuel_id, :fuel_tank_id, :current, :unit_type_id,:_destroy])
    end
end
