json.array!(@depot_fuels) do |depot_fuel|
  json.extract! depot_fuel, :unit_id, :issue_date
  json.url depot_fuel_url(depot_fuel, format: :json)
end
