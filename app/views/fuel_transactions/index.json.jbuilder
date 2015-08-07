json.array!(@fuel_transactions) do |fuel_transaction|
  json.extract! fuel_transaction, :id, :document_code, :amount, :fuel_type_id, :fuel_unit_type_id, :fuel_tank_id, :vehicle_id, :data
  json.url fuel_transaction_url(fuel_transaction, format: :json)
end
