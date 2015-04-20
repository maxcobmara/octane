json.array!(@unit_fuels) do |unit_fuel|
  json.extract! unit_fuel, :issue_date, :unit_id, :d_vessel, :d_vehicle, :d_misctool, :d_boat, :p_vehicle, :p_misctool, :p_boat
  json.url unit_fuel_url(unit_fuel, format: :json)
end
