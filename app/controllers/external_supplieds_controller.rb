class ExternalSuppliedsController < ApplicationController
  load_and_authorize_resource
  before_action :set_external_supplied, only: [:show, :edit, :update, :destroy]

  # GET /external_supplieds
  # GET /external_supplieds.json
  def index
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || current_user.staff.unit_id
      @search = ExternalSupplied.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @external_supplieds = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || current_user.staff.unit_id
        format.html
        format.csv { send_data @external_supplieds.to_csv }
        format.xls { send_data @external_supplieds.to_csv(col_sep: "\t") }
      else
        format.html {redirect_to root_path, notice: (t 'external_supplieds.title')+(t 'users.staff_required')}
      end
    end
  end

  # GET /external_supplieds/1
  # GET /external_supplieds/1.json
  def show
  end

  # GET /external_supplieds/new
  def new
    @external_supplied = ExternalSupplied.new
    @unit_fuel = UnitFuel.find(params[:unit_fuel_id])
    @external_supplied = @unit_fuel.external_supplieds.new(params[:external_supplied])
  end

  # GET /external_supplieds/1/edit
  def edit
  end

  # POST /external_supplieds
  # POST /external_supplieds.json
  def create
    @external_supplied = ExternalSupplied.new(external_supplied_params)

    respond_to do |format|
      if @external_supplied.save
        format.html { redirect_to @external_supplied, notice: 'External supplied was successfully created.' }
        format.json { render action: 'show', status: :created, location: @external_supplied }
      else
        format.html { render action: 'new' }
        format.json { render json: @external_supplied.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_supplieds/1
  # PATCH/PUT /external_supplieds/1.json
  def update
    respond_to do |format|
      if @external_supplied.update(external_supplied_params)
        format.html { redirect_to @external_supplied, notice: 'External supplied was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @external_supplied.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_supplieds/1
  # DELETE /external_supplieds/1.json
  def destroy
    @external_supplied.destroy
    respond_to do |format|
      format.html { redirect_to external_supplieds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_supplied
      @external_supplied = ExternalSupplied.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_supplied_params
      params.require(:external_supplied).permit(:unit_fuel_id, :fuel_type_id, :unit_type_id, :quantity, :source)
    end
end
