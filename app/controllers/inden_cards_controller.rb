class IndenCardsController < ApplicationController
  before_action :set_inden_card, only: [:show, :edit, :update, :destroy]

  # GET /inden_cards
  # GET /inden_cards.json
  def index
    @search = IndenCard.search(params[:q])
    @inden_cards = @search.result
  end

  # GET /inden_cards/1
  # GET /inden_cards/1.json
  def show
  end

  # GET /inden_cards/new
  def new
    @inden_card = IndenCard.new
  end

  # GET /inden_cards/1/edit
  def edit
  end

  # POST /inden_cards
  # POST /inden_cards.json
  def create
    @inden_card = IndenCard.new(inden_card_params)

    respond_to do |format|
      if @inden_card.save
        format.html { redirect_to @inden_card, notice: (t 'inden_cards.title2')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @inden_card }
      else
        format.html { render action: 'new' }
        format.json { render json: @inden_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inden_cards/1
  # PATCH/PUT /inden_cards/1.json
  def update
    respond_to do |format|
      if @inden_card.update(inden_card_params)
        format.html { redirect_to @inden_card, notice:  (t 'inden_cards.title2')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @inden_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inden_cards/1
  # DELETE /inden_cards/1.json
  def destroy
    @inden_card.destroy
    respond_to do |format|
      format.html { redirect_to inden_cards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inden_card
      @inden_card = IndenCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inden_card_params
      params.require(:inden_card).permit(:ru_staff, :serial_no, :daily_limit, :monthly_limit, :issue_date, :start_date, :end_date, :staff_id, :unit_id, inden_usages_attributes: [:id, :inden_card_id, :issue_date, :petrol_ltr, :petrol_price, :diesel_ltr, :diesel_price, :petronas_p_ltr, :petronal_p_price, :petronas_d_ltr, :petronas_d_price])
    end
end
