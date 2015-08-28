class AddFuelsController < ApplicationController
  before_action :set_add_fuel, only: [:show, :edit, :update, :destroy]

  # GET /add_fuels
  # GET /add_fuels.json
  def index
    @add_fuels = AddFuel.all
    @search = AddFuel.search(params[:q])
    @add_fuels = @search.result
  end

  # GET /add_fuels/1
  # GET /add_fuels/1.json
  def show
  end

  # GET /add_fuels/new
  def new
    @unit_fuel = UnitFuel.find(params[:unit_fuel_id])
    @add_fuel = @unit_fuel.add_fuels.new(params[:add_fuel])
    @add_fuel.save
  end

  # GET /add_fuels/1/edit
  def edit
  end

  # POST /add_fuels
  # POST /add_fuels.json
  def create
    @add_fuel = AddFuel.new(add_fuel_params)
    

    respond_to do |format|
      if @add_fuel.save
        format.html { redirect_to @add_fuel, notice: (t 'add_fuels.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @add_fuel }
      else
        format.html { render action: 'new' }
        format.json { render json: @add_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /add_fuels/1
  # PATCH/PUT /add_fuels/1.json
  def update
    respond_to do |format|
      if @add_fuel.update(add_fuel_params)
        format.html { redirect_to @add_fuel, notice: (t 'add_fuels.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @add_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /add_fuels/1
  # DELETE /add_fuels/1.json
  def destroy
    @add_fuel.destroy
    respond_to do |format|
      format.html { redirect_to add_fuels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_add_fuel
      @add_fuel = AddFuel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def add_fuel_params
      params.require(:add_fuel).permit(:unit_fuel_id, :fuel_type_id, :description, :quantity, :unit_type_id)
    end
end
