json.array!(@fuel_supplieds) do |fuel_supplied|
  json.extract! fuel_supplied, :depot_fuel_id, :fuel_type_id, :quantity, :unit_type_id
  json.url fuel_supplied_url(fuel_supplied, format: :json)
end
