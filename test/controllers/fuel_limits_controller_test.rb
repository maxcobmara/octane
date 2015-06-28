require 'test_helper'

class FuelLimitsControllerTest < ActionController::TestCase
  setup do
    @fuel_limit = fuel_limits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fuel_limits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fuel_limit" do
    assert_difference('FuelLimit.count') do
      post :create, fuel_limit: { code: @fuel_limit.code, data: @fuel_limit.data, duration: @fuel_limit.duration, emails: @fuel_limit.emails, fuel_type_id: @fuel_limit.fuel_type_id, fuel_unit_type_id: @fuel_limit.fuel_unit_type_id, limit_amount: @fuel_limit.limit_amount, limit_unit_type_id: @fuel_limit.limit_unit_type_id, unit_id: @fuel_limit.unit_id }
    end

    assert_redirected_to fuel_limit_path(assigns(:fuel_limit))
  end

  test "should show fuel_limit" do
    get :show, id: @fuel_limit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fuel_limit
    assert_response :success
  end

  test "should update fuel_limit" do
    patch :update, id: @fuel_limit, fuel_limit: { code: @fuel_limit.code, data: @fuel_limit.data, duration: @fuel_limit.duration, emails: @fuel_limit.emails, fuel_type_id: @fuel_limit.fuel_type_id, fuel_unit_type_id: @fuel_limit.fuel_unit_type_id, limit_amount: @fuel_limit.limit_amount, limit_unit_type_id: @fuel_limit.limit_unit_type_id, unit_id: @fuel_limit.unit_id }
    assert_redirected_to fuel_limit_path(assigns(:fuel_limit))
  end

  test "should destroy fuel_limit" do
    assert_difference('FuelLimit.count', -1) do
      delete :destroy, id: @fuel_limit
    end

    assert_redirected_to fuel_limits_path
  end
end
