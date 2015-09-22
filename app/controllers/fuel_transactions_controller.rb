class FuelTransactionsController < ApplicationController
  filter_resource_access
  before_action :set_fuel_transaction, only: [:show, :edit, :update, :destroy]

  # GET /fuel_transactions
  # GET /fuel_transactions.json
  def index
    is_admin=current_user.roles[:user_roles][:administration]
    if is_admin=="1" || current_user.staff_id
      @search = FuelTransaction.search_by_role(is_admin, current_user.staff_id).search(params[:q])
      @fuel_transactions = @search.result
    end
    respond_to do |format|
      if is_admin=="1" || current_user.staff_id
        format.html
      else
        format.html {redirect_to root_path, notice: (t 'users.staff_required')}
      end
    end
#     @search = FuelTransaction.search(params[:q])
#     @fuel_transactions = @search.result
  end

  # GET /fuel_transactions/1
  # GET /fuel_transactions/1.json
  def show
  end

  # GET /fuel_transactions/new
  def new
    @fuel_transaction = FuelTransaction.new(transaction_type: params[:transaction_type])
    #@fuel_transaction.transaction_type = "Usage"
  end

  def new_resupply
    @fuel_transaction = FuelTransaction.new
    #@fuel_transaction.transaction_type = "Resupply"
  end

  # GET /fuel_transactions/1/edit
  def edit
  end

  # POST /fuel_transactions
  # POST /fuel_transactions.json
  def create
    @fuel_transaction = FuelTransaction.new(fuel_transaction_params)

    respond_to do |format|
      if @fuel_transaction.save
        #TODO - refractor this - start
        limit_diesel=@fuel_transaction.diesel_limit 
        limit_petrol=@fuel_transaction.petrol_limit
        limit_avtur=@fuel_transaction.avtur_limit
        limit_avcat=@fuel_transaction.avcat_limit
        surplus_diesel=@fuel_transaction.surplus_amount(limit_diesel, @fuel_transaction.diesel_budgets)
        surplus_petrol=@fuel_transaction.surplus_amount(limit_petrol, @fuel_transaction.petrol_budgets)
        surplus_avtur=@fuel_transaction.surplus_amount(limit_avtur, @fuel_transaction.avtur_budgets)
        surplus_avcat=@fuel_transaction.surplus_amount(limit_avcat, @fuel_transaction.avcat_budgets)
        
        if surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails &&  surplus_avcat > 0 && limit_petrol.emails && limit_avcat.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, limit_avtur, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_avcat.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_avcat.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, limit_avtur, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, 0, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, 0, 0, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avtur > 0 &&  surplus_petrol > 0 && limit_avtur.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, 0, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_diesel > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, 0, limit_avcat, @fuel_transaction).deliver_now 
        else
          if surplus_diesel > 0
            NotificationMailer.notify_email_transaction(limit_diesel, @fuel_transaction).deliver_now
          end
          if surplus_petrol > 0 
            NotificationMailer.notify_email_transaction(limit_petrol, @fuel_transaction).deliver_now
          end
          if surplus_avtur > 0 
            NotificationMailer.notify_email_transaction(limit_avtur, @fuel_transaction).deliver_now
          end
          if surplus_avcat > 0 
            NotificationMailer.notify_email_transaction(limit_avcat, @fuel_transaction).deliver_now
          end
        end
        #TODO - refractor this - end
        format.html { redirect_to @fuel_transaction, notice: 'Fuel transaction was successfully created.' }
        format.json { render :show, status: :created, location: @fuel_transaction }
      else
        format.html { render :new }
        format.json { render json: @fuel_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_transactions/1
  # PATCH/PUT /fuel_transactions/1.json
  def update
    respond_to do |format|
      if @fuel_transaction.update(fuel_transaction_params)
        #TODO - refractor this - start
        limit_diesel=@fuel_transaction.diesel_limit 
        limit_petrol=@fuel_transaction.petrol_limit
        limit_avtur=@fuel_transaction.avtur_limit
        limit_avcat=@fuel_transaction.avcat_limit
        surplus_diesel=@fuel_transaction.surplus_amount(limit_diesel, @fuel_transaction.diesel_budgets)
        surplus_petrol=@fuel_transaction.surplus_amount(limit_petrol, @fuel_transaction.petrol_budgets)
        surplus_avtur=@fuel_transaction.surplus_amount(limit_avtur, @fuel_transaction.avtur_budgets)
        surplus_avcat=@fuel_transaction.surplus_amount(limit_avcat, @fuel_transaction.avcat_budgets)
        
        if surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails &&  surplus_avcat > 0 && limit_petrol.emails && limit_avcat.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, limit_avtur, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_avcat.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_avcat.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, limit_avtur, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, 0, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, limit_petrol, 0, 0, @fuel_transaction).deliver_now 
        elsif  surplus_diesel > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avtur > 0 &&  surplus_petrol > 0 && limit_avtur.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, limit_avtur, 0, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(0, limit_petrol, 0, limit_avcat, @fuel_transaction).deliver_now 
        elsif  surplus_avcat > 0 &&  surplus_diesel > 0 && limit_diesel.emails==limit_petrol.emails
            NotificationMailer.notify_email_combine_transaction(limit_diesel, 0, 0, limit_avcat, @fuel_transaction).deliver_now 
        else
          if surplus_diesel > 0
            NotificationMailer.notify_email_transaction(limit_diesel, @fuel_transaction).deliver_now
          end
          if surplus_petrol > 0 
            NotificationMailer.notify_email_transaction(limit_petrol, @fuel_transaction).deliver_now
          end
          if surplus_avtur > 0 
            NotificationMailer.notify_email_transaction(limit_avtur, @fuel_transaction).deliver_now
          end
          if surplus_avcat > 0 
            NotificationMailer.notify_email_transaction(limit_avcat, @fuel_transaction).deliver_now
          end
        end
        #TODO - refractor this - end
        format.html { redirect_to @fuel_transaction, notice: 'Fuel transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @fuel_transaction }
      else
        format.html { render :edit }
        format.json { render json: @fuel_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_transactions/1
  # DELETE /fuel_transactions/1.json
  def destroy
    @fuel_transaction.destroy
    respond_to do |format|
      format.html { redirect_to fuel_transactions_url, notice: 'Fuel transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def vehicle_vessel_usage
    start=Date.today.beginning_of_year
    current=Date.today+1.day
    @fuel_transactions=FuelTransaction.usage.where('created_at >=? and created_at<=?', start, current)
    cars_category_ids=VehicleCategory.cars.pluck(:id)
    lorries_category_ids=VehicleCategory.lorries.pluck(:id)
    busses_category_ids=VehicleCategory.busses.pluck(:id)
    @cars=Vehicle.where(category_id: cars_category_ids).pluck(:id)
    @lorries=Vehicle.where(category_id: lorries_category_ids).pluck(:id)
    @busses=Vehicle.where(category_id: busses_category_ids).pluck(:id)
    @no_cat=Vehicle.where(category_id: nil).pluck(:id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_transaction
      @fuel_transaction = FuelTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_transaction_params
      params.require(:fuel_transaction).permit(:document_code, :transaction_type, :amount, :fuel_type_id, :fuel_unit_type_id, :fuel_tank_id, :vehicle_id, :data, :created_by, :updated_by, :vessel_id, :is_vehicle)
    end
end
