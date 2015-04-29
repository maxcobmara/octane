json.array!(@fuel_issueds) do |fuel_issued|
  json.extract! fuel_issued, :depot_fuel_id, :fuel_type_id, :quantity
  json.url fuel_issued_url(fuel_issued, format: :json)
end
