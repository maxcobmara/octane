json.array!(@fuel_limits) do |fuel_limit|
  json.extract! fuel_limit, :id, :code, :unit_id, :limit_amount, :limit_unit_type_id, :duration, :fuel_type_id, :fuel_unit_type_id, :emails, :data
  json.url fuel_limit_url(fuel_limit, format: :json)
end
