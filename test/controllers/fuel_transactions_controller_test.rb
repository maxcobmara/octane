require 'test_helper'

class FuelTransactionsControllerTest < ActionController::TestCase
  setup do
    @fuel_transaction = fuel_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fuel_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fuel_transaction" do
    assert_difference('FuelTransaction.count') do
      post :create, fuel_transaction: { amount: @fuel_transaction.amount, data: @fuel_transaction.data, document_code: @fuel_transaction.document_code, fuel_tank_id: @fuel_transaction.fuel_tank_id, fuel_type_id: @fuel_transaction.fuel_type_id, fuel_unit_type_id: @fuel_transaction.fuel_unit_type_id, vehicle_id: @fuel_transaction.vehicle_id }
    end

    assert_redirected_to fuel_transaction_path(assigns(:fuel_transaction))
  end

  test "should show fuel_transaction" do
    get :show, id: @fuel_transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fuel_transaction
    assert_response :success
  end

  test "should update fuel_transaction" do
    patch :update, id: @fuel_transaction, fuel_transaction: { amount: @fuel_transaction.amount, data: @fuel_transaction.data, document_code: @fuel_transaction.document_code, fuel_tank_id: @fuel_transaction.fuel_tank_id, fuel_type_id: @fuel_transaction.fuel_type_id, fuel_unit_type_id: @fuel_transaction.fuel_unit_type_id, vehicle_id: @fuel_transaction.vehicle_id }
    assert_redirected_to fuel_transaction_path(assigns(:fuel_transaction))
  end

  test "should destroy fuel_transaction" do
    assert_difference('FuelTransaction.count', -1) do
      delete :destroy, id: @fuel_transaction
    end

    assert_redirected_to fuel_transactions_path
  end
end
