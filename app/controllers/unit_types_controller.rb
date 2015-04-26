class UnitTypesController < ApplicationController
  before_action :set_unit_type, only: [:show, :edit, :update, :destroy]

  # GET /unit_types
  # GET /unit_types.json
  def index
    @unit_types = UnitType.all
	@unit_type = UnitType.new
  end

  # GET /unit_types/1
  # GET /unit_types/1.json
  #def show
  #end

  # GET /unit_types/new
  def new
    @unit_type = UnitType.new
  end

  # GET /unit_types/1/edit
  def edit
  end

  # POST /unit_types
  # POST /unit_types.json
  def create
    @unit_type = UnitType.new(unit_type_params)

    respond_to do |format|
      if @unit_type.save
        format.html { redirect_to @unit_type, notice: 'Unit type was successfully created.' }
		    format.js
        format.json { render action: 'show', status: :created, location: @unit_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @unit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unit_types/1
  # PATCH/PUT /unit_types/1.json
  def update
	@unit_types = UnitType.all
	@unit_type = UnitType.find(params[:id])
    respond_to do |format|
      if @unit_type.update(unit_type_params)
        format.html { redirect_to @unit_type, notice: 'Unit type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_types/1
  # DELETE /unit_types/1.json
  def destroy
	@unit_type = UnitType.find(params[:id])
    @unit_type.destroy
    respond_to do |format|
      format.html { redirect_to unit_types_url }
	  format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_type
      @unit_type = UnitType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_type_params
      params.require(:unit_type).permit(:short_name, :description)
    end
end
