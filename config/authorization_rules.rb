authorization do

 role :administration do
   has_omnipotence
   has_permission_on :authorization_rules, :to => :read
 end
 
 role :data_entry do
   has_permission_on [:units, :vessels, :inden_cards, :fuel_types, :unit_types, :vessel_types, :vessel_categories], :to => :manage
   has_permission_on [:fuel_transactions, :depot_fuels, :fuel_supplieds, :fuel_issueds, :fuel_balances, :add_fuels, :external_issueds, :external_supplieds, :inden_usages, :fuel_limits], :to => :manage
   has_permission_on :depot_fuels, :to => [:manage, :import_excel, :import]
   has_permission_on :fuel_tanks, :to => [:manage, :tank_capacity_chart, :tank_capacity_list]
   has_permission_on :unit_fuels, :to => [:manage, :fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
   has_permission_on :fuel_budgets, :to => [:manage, :annual_budget]
 end
 
 role :guest do
#    has_permission_on :fuel_tanks, :to => [:tank_capacity_chart, :tank_capacity_list]
#    has_permission_on :unit_fuels, :to => [:fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
#    has_permission_on :fuel_budgets, :to => [:annual_budget]
#    has_permission_on :fuel_balances, :to => :read
   
   has_permission_on [:units, :vessels, :inden_cards, :fuel_types, :unit_types, :vessel_types, :vessel_categories], :to => :read
   has_permission_on [:fuel_transactions, :depot_fuels, :fuel_supplieds, :fuel_issueds, :fuel_balances, :add_fuels, :external_issueds, :external_supplieds, :inden_usages, :fuel_limits], :to => :read
   has_permission_on :depot_fuels, :to => :read
   has_permission_on :fuel_tanks, :to => [:read, :tank_capacity_chart, :tank_capacity_list]
   has_permission_on :unit_fuels, :to => [:read, :fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
   has_permission_on :fuel_budgets, :to => [:read, :annual_budget]
 end

end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
