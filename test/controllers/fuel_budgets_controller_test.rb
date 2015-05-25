require 'test_helper'

class FuelBudgetsControllerTest < ActionController::TestCase
  setup do
    @fuel_budget = fuel_budgets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fuel_budgets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fuel_budget" do
    assert_difference('FuelBudget.count') do
      post :create, fuel_budget: { amount: @fuel_budget.amount, code: @fuel_budget.code, fuel_type_id: @fuel_budget.fuel_type_id, parent_id: @fuel_budget.parent_id, unit_id: @fuel_budget.unit_id, unit_type_id: @fuel_budget.unit_type_id, year_starts_on: @fuel_budget.year_starts_on }
    end

    assert_redirected_to fuel_budget_path(assigns(:fuel_budget))
  end

  test "should show fuel_budget" do
    get :show, id: @fuel_budget
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fuel_budget
    assert_response :success
  end

  test "should update fuel_budget" do
    patch :update, id: @fuel_budget, fuel_budget: { amount: @fuel_budget.amount, code: @fuel_budget.code, fuel_type_id: @fuel_budget.fuel_type_id, parent_id: @fuel_budget.parent_id, unit_id: @fuel_budget.unit_id, unit_type_id: @fuel_budget.unit_type_id, year_starts_on: @fuel_budget.year_starts_on }
    assert_redirected_to fuel_budget_path(assigns(:fuel_budget))
  end

  test "should destroy fuel_budget" do
    assert_difference('FuelBudget.count', -1) do
      delete :destroy, id: @fuel_budget
    end

    assert_redirected_to fuel_budgets_path
  end
end
