Rails.application.routes.draw do


  resources :fuel_transactions do
    collection do
      get 'vehicle_vessel_usage'
    end
  end
  resources :fuel_limits
  resources :fuel_budgets do
    collection do
      get 'annual_budget'
    end
  end
  resources :external_issueds
  resources :external_supplieds
  resources :add_fuels
  resources :unit_fuels do
    collection do
      get 'unit_fuel_usage'
      post 'unit_fuel_usage'
      get 'unit_fuel_list_usage'
      post 'unit_fuel_list_usage'
      get 'annual_usage_report'
      post 'annual_usage_report'
      get 'daily_usage'
      get 'fuel_type_usage_category'
      post 'fuel_type_usage_category'
    end
  end
  resources :fuel_tanks do
    collection do
      get 'tank_capacity_list'
      get 'tank_capacity_chart'
    end
  end

  resources :fuel_balances
  resources :fuel_types
  resources :unit_types
  resources :units
  resources :fuel_supplieds

  resources :fuel_issueds
  resources :vessels
  resources :vessel_types
  resources :vessel_categories
  
  resources :depot_fuels do
    collection do
      get 'PMP_monthly_usage'
      post :import
    end
  end

  match '/public/excel_format/DepotFuel_Excel.xls', to: 'depot_fuels#download_excel_format', via: 'get', target: '_self'
  match 'import_excel_depot_fuel', to:'depot_fuels#import_excel', via: 'get'


  devise_for :users
  resources :users

  root to:  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
