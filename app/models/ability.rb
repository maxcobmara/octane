class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    my_roles = user.role_symbols
    
    if my_roles.include? :administration
      can :manage, :all
    end
    
    if my_roles.include? :data_entry
      can :manage, :units
      can :manage, :vessels
      can :manage, :inden_cards
      can :manage, :fuel_types
      can :manage, :fuel_tanks
      can :manage, :unit_types
      can :manage, :vessel_types
      can :manage, :vessel_categories
      
      can :create, UnitFuel
      can [:read, :update, :delete], UnitFuel, unit_id: user.staff.unit_id
      
      can :create, DepotFuel
      can [:read, :update, :delete, :import_excel, :import], DepotFuel, unit_id: user.staff.unit_id
      
      can :create, FuelTransaction
      can [:read,], FuelTransaction, unit_id: user.staff.unit_id
      
      can :create, FuelLimit
      can [:read, :update, :delete], FuelLimit, unit_id: user.staff.unit_id
      
      can :create, FuelBudget
      can [:read, :update, :delete], FuelBudget, unit_id: user.staff.unit_id
      
      #if_attribute :unit_fuel_id => is_in {UnitFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
      can :create, AddFuel
      can [:read, :update, :delete], AddFuel, unit_fuel_id: user.staff.unit_id

      can :create, ExternalIssued
      can [:read, :update, :delete], ExternalIssued, unit_fuel_id: user.staff.unit_id

      can :create, ExternalSupplied
      can [:read, :update, :delete], ExternalSupplied, unit_fuel_id: user.staff.unit_id

      can :create, IndenUsage
      can [:read, :update, :delete], IndenUsage, unit_fuel_id: user.staff.unit_id
      
      #Depot Fuel
      #if_attribute :depot_fuel_id =>  is_in {DepotFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
      can :create, FuelSupplied
      can [:read, :update, :delete], FuelSupplied, depot_fuel_id: user.staff.unit_id
      
      can :create, FuelIssued
      can [:read, :update, :delete], FuelIssued, depot_fuel_id: user.staff.unit_id
      
      can :create, FuelBalance
      can [:read, :update, :delete], FuelBalance, depot_fuel_id: user.staff.unit_id
      
      #to => :read, :join_by => :or do
      #if_attribute :vehicle_id => is_in {VehicleAssignmentDetail.where(vehicle_assignment_id: VehicleAssignment.where(unit_id: user.staff.unit_id).pluck(:id)).pluck(:vehicle_id)}
      #if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
      #if_attribute :vessel_id => is_in {Vessel.where(unit_id: user.staff.unit_id).pluck(:id)}  
      can [:read], FuelTransaction, unit_id: user.staff.unit_id
      
      #if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
      can [:update, :delete], FuelTransaction, fuel_tank_id: user.staff.unit_id
      
      #includes :guest ? <-- how?
    end
    
    if my_roles.include? :guest
      can :read, :fuel_supplieds
      can :read, :fuel_issueds
      can :read, :fuel_balances
      
      can :read, :unit_fuels,   unit_id: user.staff.unit_id
      can :read, :depot_fuels,  unit_id: user.staff.unit_id
      can :read, :fuel_limits,  unit_id: user.staff.unit_id
      
      can [:fuel_type_usage_category, :unit_fuel_usage, :unit_fuel_list_usage, :annual_usage_report], :unit_fuels
      
      #if_attribute :unit_fuel_id => is_in {UnitFuel.where(unit_id: user.staff.unit_id).pluck(:id)}
      can :read, :add_fuels, unit_fuel_id: user.staff.unit_id
      can :read, :external_issueds, unit_fuel_id: user.staff.unit_id
      can :read, :external_supplieds, unit_fuel_id: user.staff.unit_id
      can :read, :inden_usages, unit_fuel_id: user.staff.unit_id      
      
      can [:depot_monthly_usage], :depot_fuels
      
      #if_attribute :vehicle_id =>  is_in {VehicleAssignmentDetail.where(vehicle_assignment_id: VehicleAssignment.where(unit_id: user.staff.unit_id).pluck(:id)).pluck(:vehicle_id)}
      #if_attribute :fuel_tank_id =>  is_in {FuelTank.where(unit_id: user.staff.unit_id).pluck(:id)}
      #if_attribute :vessel_id =>  is_in {Vessel.where(unit_id: user.staff.unit_id).pluck(:id)}  
      can :read, :fuel_transactions
      
      can [:read, :annual_budget, :budget_vs_usage, :budget_vs_usage_list], :fuel_budgets
    end
    
    
    
    if user.roles.any? || user.roles.blank?
      can :read, :units
      can :read, :vessels
      can :read, :inden_cards
      can :read, :fuel_types
      can :read, :unit_types
      can :read, :vessel_types
      
      can [:read, :tank_capacity_chart, :tank_capacity_list], :fuel_tanks
    end
    
  end
end