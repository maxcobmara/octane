json.array!(@external_issueds) do |external_issued|
  json.extract! external_issued, :unit_fuel_id, :fuel_type_id, :unit_type_id, :quantity, :source
  json.url external_issued_url(external_issued, format: :json)
end
