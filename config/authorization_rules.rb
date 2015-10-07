authorization do

 role :administration do
   has_omnipotence
   has_permission_on :authorization_rules, :to => :read
 end
 
 role :data_entry do
   has_permission_on [:units, :vessels, :inden_cards, :fuel_types, :unit_types, :vessel_types, :vessel_categories], :to => :manage
   has_permission_on  :fuel_tanks, :to => :manage   
   
   #Unit Fuel
   has_permission_on :unit_fuels, :to => :create
   has_permission_on :unit_fuels, :to => [:read, :update, :delete] do 
     if_attribute :unit_id => is {user.staff.unit_id}
   end
   has_permission_on  [:add_fuels, :external_issueds, :external_supplieds, :inden_usages], :to => :create
   has_permission_on [:add_fuels, :external_issueds, :external_supplieds, :inden_usages], :to => [:read, :update, :delete] do
     if_attribute :unit_fuel_id => is_in {UnitFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
   end
   
   #Depot Fuel
   has_permission_on :depot_fuels, :to => :create
   has_permission_on :depot_fuels, :to => [:read, :update, :delete, :import_excel, :import] do
     if_attribute :unit_id => is {user.staff.unit_id }
   end
   has_permission_on [:fuel_supplieds, :fuel_issueds, :fuel_balances], :to => :create
   has_permission_on [:fuel_supplieds, :fuel_issueds, :fuel_balances], :to => [:read, :update, :delete] do
     if_attribute :depot_fuel_id =>  is_in {DepotFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
   end

   has_permission_on :fuel_transactions, :to => :create
   has_permission_on :fuel_transactions, :to => :read, :join_by => :or do
     if_attribute :vehicle_id => is_in {VehicleAssignmentDetail.where(vehicle_assignment_id: VehicleAssignment.where(unit_id: user.staff.unit_id).pluck(:id)).pluck(:vehicle_id)}
     if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
     if_attribute :vessel_id => is_in {Vessel.where(unit_id: user.staff.unit_id).pluck(:id)}  
   end
   has_permission_on :fuel_transactions, :to => [:update, :delete] do
     if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
   end
   
   has_permission_on [:fuel_limits, :fuel_budgets], :to => :create
   has_permission_on [:fuel_limits, :fuel_budgets], :to => [:update, :delete] do
     if_attribute :unit_id => is {user.staff.unit_id}
   end
   
   includes :guest
 end

 #Unit Fuel - REPORT -  :fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report] do
 #Depot Fuel - REPORT - depot_monthly_usage 
 #fuel tank - REPORT -  :tank_capacity_chart, :tank_capacity_list
 #fuel budget - REPORT - :annual_budget, :budget_vs_usage, :budget_vs_usage_list
 
 role :guest do  
   has_permission_on [:units, :vessels, :inden_cards, :fuel_types, :unit_types, :vessel_types, :vessel_categories], :to => :read
   has_permission_on :fuel_tanks, :to => [:read, :tank_capacity_chart, :tank_capacity_list]
   
   #Unit Fuel
   has_permission_on :unit_fuels, :to => :read do
     if_attribute :unit_id => is {user.staff.unit_id}
   end
   has_permission_on :unit_fuels, :to => [:fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report]
   has_permission_on [:add_fuels, :external_issueds, :external_supplieds, :inden_usages], :to => :read do
     if_attribute :unit_fuel_id => is_in {UnitFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
   end
   
   #Depot Fuel
   has_permission_on :depot_fuels, :to => :read do
     if_attribute :unit_id => is {user.staff.unit_id}
   end
   has_permission_on :depot_fuels, :to =>[:depot_monthly_usage] 
   has_permission_on [:fuel_supplieds, :fuel_issueds, :fuel_balances], :to => :read
   
   has_permission_on :fuel_transactions, :to => :read, :join_by => :or do
     if_attribute :vehicle_id =>  is_in {VehicleAssignmentDetail.where(vehicle_assignment_id: VehicleAssignment.where(unit_id: user.staff.unit_id).pluck(:id)).pluck(:vehicle_id)}
     if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
     if_attribute :vessel_id =>  is_in {Vessel.where(unit_id: user.staff.unit_id).pluck(:id)}  
   end
   
   has_permission_on :fuel_budgets, :to => [:read, :annual_budget, :budget_vs_usage, :budget_vs_usage_list]
   has_permission_on :fuel_limits, :to => :read do
     if_attribute :unit_id => is {user.staff.unit_id}
   end
   
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
