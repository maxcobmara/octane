class FuelTransactionsController < ApplicationController
  before_action :set_fuel_transaction, only: [:show, :edit, :update, :destroy]

  # GET /fuel_transactions
  # GET /fuel_transactions.json
  def index
    @fuel_transactions = FuelTransaction.all
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_transaction
      @fuel_transaction = FuelTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_transaction_params
      params.require(:fuel_transaction).permit(:document_code, :amount, :fuel_type_id, :fuel_unit_type_id, :fuel_tank_id, :vehicle_id, :data)
    end
end
