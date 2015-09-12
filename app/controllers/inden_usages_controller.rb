class IndenUsagesController < ApplicationController
  filter_resource_access
  before_action :set_inden_usage, only: [:show, :edit, :update, :destroy]

  # GET /inden_usages
  # GET /inden_usages.json
  def index
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || current_user.staff_id
      @search = IndenUsage.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @inden_usages = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || current_user.staff_id
        format.html
        format.csv { send_data @inden_usages.to_csv }
        format.xls { send_data @inden_usages.to_csv(col_sep: "\t") }
      else
        format.html {redirect_to root_path, notice: (t 'users.staff_required')}
      end
    end
#     @search = IndenUsage.search(params[:q])
#     @inden_usages = @search.result
  end

  # GET /inden_usages/1
  # GET /inden_usages/1.json
  def show
  end

  # GET /inden_usages/new
  def new
    ##@inden_usage = IndenUsage.new
    #@inden_card = IndenCard.find(params[:inden_card_id])
    #@inden_usage= @inden_card.inden_usages.new(params[:inden_usage])
    #@inden_usage.save
    
    @unit_fuel = UnitFuel.find(params[:unit_fuel_id])
    @inden_usage = @unit_fuel.inden_usages.new(params[:inden_usage])
  end

  # GET /inden_usages/1/edit
  def edit
  end

  # POST /inden_usages
  # POST /inden_usages.json
  def create
    @inden_usage = IndenUsage.new(inden_usage_params)

    respond_to do |format|
      if @inden_usage.save
        format.html { redirect_to @inden_usage, notice: (t 'inden_usages.title2')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @inden_usage }
      else
        format.html { render action: 'new' }
        format.json { render json: @inden_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inden_usages/1
  # PATCH/PUT /inden_usages/1.json
  def update
    respond_to do |format|
      if @inden_usage.update(inden_usage_params)
        format.html { redirect_to @inden_usage, notice: (t 'inden_usages.title2')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @inden_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inden_usages/1
  # DELETE /inden_usages/1.json
  def destroy
    @inden_usage.destroy
    respond_to do |format|
      format.html { redirect_to inden_usages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inden_usage
      @inden_usage = IndenUsage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inden_usage_params
      params.require(:inden_usage).permit(:inden_card_id, :petrol_ltr, :petrol_price, :diesel_ltr, :diesel_price, :issue_date, :petronas_p_ltr, :petronal_p_price, :petronas_d_ltr, :petronas_d_price, :unit_fuel_id)
    end
end
