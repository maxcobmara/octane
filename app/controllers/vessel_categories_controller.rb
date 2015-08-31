class VesselCategoriesController < ApplicationController
  before_action :set_vessel_category, only: [:show, :edit, :update, :destroy]

  # GET /vessel_categories
  # GET /vessel_categories.json
  def index
    @search = VesselCategory.search(params[:q])
    @vessel_categories = @search.result
#     @vessel_categories = VesselType.all
#     @vessel_category = VesselType.new
  end

  # GET /vessel_categories/1
  # GET /vessel_categories/1.json
  def show
  end

  # GET /vessel_categories/new
  def new
    @vessel_category = VesselCategory.new
  end

  # GET /vessel_categories/1/edit
  def edit
  end

  # POST /vessel_categories
  # POST /vessel_categories.json
  def create
    @vessel_category = VesselCategory.new(vessel_category_params)

    respond_to do |format|
      if @vessel_category.save
        format.html { redirect_to @vessel_category, notice: 'Vessel class was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @vessel_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @vessel_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vessel_categories/1
  # PATCH/PUT /vessel_categories/1.json
  def update
    respond_to do |format|
      if @vessel_category.update(vessel_category_params)
        format.html { redirect_to @vessel_category, notice: 'Vessel class was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vessel_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vessel_categories/1
  # DELETE /vessel_categories/1.json
  def destroy
    @vessel_category.destroy
    respond_to do |format|
      format.html { redirect_to vessel_categories_url }
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vessel_category
      @vessel_category = VesselCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vessel_category_params
      params.require(:vessel_category).permit(:short_name, :description, :vessel_type_id)
    end
end
