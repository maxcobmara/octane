json.array!(@external_supplieds) do |external_supplied|
  json.extract! external_supplied, :unit_fuel_id, :fuel_type_id, :unit_type_id, :quantity, :source
  json.url external_supplied_url(external_supplied, format: :json)
end
