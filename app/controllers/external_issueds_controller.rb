class ExternalIssuedsController < ApplicationController
  before_action :set_external_issued, only: [:show, :edit, :update, :destroy]

  # GET /external_issueds
  # GET /external_issueds.json
  def index
    @external_issueds = ExternalIssued.all
    @search = ExternalIssued.search(params[:q])
    @external_issueds = @search.result
  end

  # GET /external_issueds/1
  # GET /external_issueds/1.json
  def show
  end

  # GET /external_issueds/new
  def new
    @unit_fuel = UnitFuel.find(params[:unit_fuel_id])
    @external_issued = @unit_fuel.external_issueds.new(params[:external_issued])
    @external_issued.save
  end

  # GET /external_issueds/1/edit
  def edit
  end

  # POST /external_issueds
  # POST /external_issueds.json
  def create
    @external_issued = ExternalIssued.new(external_issued_params)

    respond_to do |format|
      if @external_issued.save
        format.html { redirect_to @external_issued, notice: 'External issued was successfully created.' }
        format.json { render action: 'show', status: :created, location: @external_issued }
      else
        format.html { render action: 'new' }
        format.json { render json: @external_issued.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_issueds/1
  # PATCH/PUT /external_issueds/1.json
  def update
    respond_to do |format|
      if @external_issued.update(external_issued_params)
        format.html { redirect_to @external_issued, notice: 'External issued was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @external_issued.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_issueds/1
  # DELETE /external_issueds/1.json
  def destroy
    @external_issued.destroy
    respond_to do |format|
      format.html { redirect_to external_issueds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_issued
      @external_issued = ExternalIssued.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_issued_params
      params.require(:external_issued).permit(:unit_fuel_id, :fuel_type_id, :unit_type_id, :quantity, :source)
    end
end
