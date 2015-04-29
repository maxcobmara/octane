class FuelTanksController < ApplicationController
  before_action :set_fuel_tank, only: [:show, :edit, :update, :destroy]

  # GET /fuel_tanks
  # GET /fuel_tanks.json
  def index
    @fuel_tanks = FuelTank.where("capacity > ?", 0).order(fuel_type_id: :asc).all
    @search = FuelTank.search(params[:q])
    @fuel_tanks = @search.result
  end

  # GET /fuel_tanks/1
  # GET /fuel_tanks/1.json
  def show
  end

  # GET /fuel_tanks/new
  def new
    @fuel_tank = FuelTank.new
  end

  # GET /fuel_tanks/1/edit
  def edit
  end

  # POST /fuel_tanks
  # POST /fuel_tanks.json
  def create
    @fuel_tank = FuelTank.new(fuel_tank_params)

    respond_to do |format|
      if @fuel_tank.save
        format.html { redirect_to @fuel_tank, notice: (t 'fuel_tanks.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @fuel_tank }
      else
        format.html { render action: 'new' }
        format.json { render json: @fuel_tank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_tanks/1
  # PATCH/PUT /fuel_tanks/1.json
  def update
    respond_to do |format|
      if @fuel_tank.update(fuel_tank_params)
        format.html { redirect_to @fuel_tank, notice: (t 'fuel_tanks.title')+(t 'actions.updated')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fuel_tank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_tanks/1
  # DELETE /fuel_tanks/1.json
  def destroy
    @fuel_tank.destroy
    respond_to do |format|
      format.html { redirect_to fuel_tanks_url }
      format.json { head :no_content }
    end
  end

  def tank_capacity
      @fuel_tanks = FuelTank.all.order(:unit_id)
  end
  
  def tank_capacity
    @fuel_tanks = FuelTank.where("capacity > ?", 0).order(fuel_type_id: :asc).all
    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_tank
      @fuel_tank = FuelTank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_tank_params
      params.require(:fuel_tank).permit(:unit_id, :locations, :capacity, :unit_type, :fuel_type_id)
    end
end
