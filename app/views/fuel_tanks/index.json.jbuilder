json.array!(@fuel_tanks) do |fuel_tank|
  json.extract! fuel_tank, :unit_id, :locations, :capacity, :unit_type, :fuel_type_id
  json.url fuel_tank_url(fuel_tank, format: :json)
end
