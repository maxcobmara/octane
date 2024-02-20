class FuelIssuedsController < ApplicationController
  load_and_authorize_resource
  before_action :set_fuel_issued, only: [:show, :edit, :update, :destroy]

  # GET /fuel_issueds
  # GET /fuel_issueds.json
  def index
    # HACK - refer header - avoid Unit user, using direct url
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
      @search = FuelIssued.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @fuel_issueds = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || (current_user.staff.unit_id && Unit.is_depot.pluck(:id).include?(current_user.staff.unit_id))
        format.html
      else
        format.html {redirect_to root_path, notice: (t 'fuel_issueds.title3')+(t 'users.depot_staff_required')}
      end
    end
  end

  # GET /fuel_issueds/1
  # GET /fuel_issueds/1.json
  def show
  end

  # GET /fuel_issueds/new
  def new
    @depot_fuel = DepotFuel.find(params[:depot_fuel_id])
    @fuel_issued = @depot_fuel.fuel_issueds.new(params[:fuel_issued])
  end

  # GET /fuel_issueds/1/edit
  def edit
  end

  # POST /fuel_issueds
  # POST /fuel_issueds.json
  def create
    @fuel_issued = FuelIssued.new(fuel_issued_params)

    respond_to do |format|
      if @fuel_issued.save
        format.html { redirect_to @fuel_issued, notice: (t 'fuel_issueds.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @fuel_issued }
      else
        format.html { render action: 'new' }
        format.json { render json: @fuel_issued.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_issueds/1
  # PATCH/PUT /fuel_issueds/1.json
  def update
    respond_to do |format|
      if @fuel_issued.update(fuel_issued_params)
        format.html { redirect_to @fuel_issued, notice: (t 'fuel_issueds.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fuel_issued.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_issueds/1
  # DELETE /fuel_issueds/1.json
  def destroy
    @fuel_issued.destroy
    respond_to do |format|
      format.html { redirect_to fuel_issueds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_issued
      @fuel_issued = FuelIssued.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_issued_params
      params.require(:fuel_issued).permit(:depot_fuel_id, :fuel_type_id, :quantity,:unit_type_id, :unit_id)
    end
end
