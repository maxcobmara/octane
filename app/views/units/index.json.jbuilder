json.array!(@units) do |unit|
  json.extract! unit, :shortname, :name, :parent_id
  json.url unit_url(unit, format: :json)
end
