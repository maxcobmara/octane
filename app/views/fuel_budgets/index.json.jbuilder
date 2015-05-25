json.array!(@fuel_budgets) do |fuel_budget|
  json.extract! fuel_budget, :id, :parent_id, :code, :unit_id, :year_starts_on, :fuel_type_id, :amount, :unit_type_id
  json.url fuel_budget_url(fuel_budget, format: :json)
end
