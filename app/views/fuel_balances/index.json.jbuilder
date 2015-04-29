json.array!(@fuel_balances) do |fuel_balance|
  json.extract! fuel_balance, :depot_fuel_id, :fuel_tank_id, :current
  json.url fuel_balance_url(fuel_balance, format: :json)
end
