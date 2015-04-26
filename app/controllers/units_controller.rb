class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    #@units = Unit.all  
    #depot vs unit
    @depot = params[:id]
	@search = Unit.search(params[:q])
    if @depot == 1 || @depot == '1'
      @units = Unit.where("id IN(?)",FuelTank.pluck(:unit_id))
      #@units = Unit.find(:all, :conditions=>['id IN (?)',FuelTank.all.map(&:unit_id)])
    elsif @depot == 0 || @depot == '0'
      @units = Unit.all
	else 
	 @units = @search.result
    end 
    
    #@search = Unit.search(params[:q])
    #@units = @search.result
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new(:parent_id => params[:parent_id])
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @unit }
      else
        format.html { render action: 'new' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:shortname, :name, :ancestry, :ancestry_depth, :parent_id, :code, :combo_code)
    end
end
