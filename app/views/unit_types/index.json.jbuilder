json.array!(@unit_types) do |unit_type|
  json.extract! unit_type, :short_name, :description
  json.url unit_type_url(unit_type, format: :json)
end
