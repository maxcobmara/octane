module DepotFuelsHelper
  #Below - used for REAL TIME notification, whereas those in Fuel Limit used for DISPLAY purpose for all notification throughout the budget year
  def diesel_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id)
  end
  
  def petrol_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id)
  end
  
  def avtur_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id)
  end
  
  def avcat_budgets
    FuelBudget.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id)
  end
  
  def diesel_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'DIESEL').first.id).first
  end
  
  def petrol_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'PETROL').first.id).first
  end
  
  def avtur_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVTUR').first.id).first
  end
  
  def avcat_limit
    FuelLimit.where(unit_id: unit_id).where(fuel_type_id: FuelType.where(name: 'AVCAT').first.id).first
  end
   
  def usages(limit, budgets)
    if budgets.count > 0
      budget_start_date=budgets.order(year_starts_on: :desc).last.year_starts_on
      if limit
        days_diff = (Date.today-budget_start_date.to_date).to_i
        days_no = days_diff  % (limit.duration-1)  #days_diff  % limit.duration
#         limit_set = days_diff / limit.duration
        if days_no == 0 && days_diff > 0
#           if limit_set==0
#             limitstart=Date.today-days_diff
#           else
#             limitstart=Date.today-(days_diff*limit_set)
#           end
          limitstart=Date.today-limit.duration
          usages_rec=FuelIssued.joins(:depot_fuel).where('depot_fuels.unit_id=?', limit.unit_id).where('depot_fuels.issue_date >=? and depot_fuels. issue_date <=?', limitstart, Date.today).where(fuel_type: limit.fuel_type)
         end
      end
    end
    usages_rec
  end
  
  def usage_amount(limit, budgets)
    usages(limit, budgets).sum(:quantity)
  end
  
  def surplus_amount(limit, budgets)
    if limit && usages(limit, budgets)
      if usages(limit, budgets).first.unit_type==limit.limit_unit_type 
        if usage_amount(limit, budgets) > limit.limit_amount
          surplus= usage_amount(limit, budgets) - limit.limit_amount
        else
          surplus=0
        end
      else
        surplus=0
      end
    else
      surplus=0
    end
    surplus
  end
  
  def surplus_notification
    limit_diesel=diesel_limit 
    limit_petrol=petrol_limit
    limit_avtur=avtur_limit
    limit_avcat=avcat_limit
    surplus_diesel=surplus_amount(limit_diesel, diesel_budgets)
    surplus_petrol=surplus_amount(limit_petrol, petrol_budgets)
    surplus_avtur=surplus_amount(limit_avtur, avtur_budgets)
    surplus_avcat=surplus_amount(limit_avcat, avcat_budgets)
        
    if surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails &&  surplus_avcat > 0 && limit_petrol.emails && limit_avcat.emails
      NotificationMailer.notify_email_combine(limit_diesel, limit_petrol, limit_avtur, limit_avcat, id).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_avcat.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_avcat.emails==limit_avtur.emails
      NotificationMailer.notify_email_combine(0, limit_petrol, limit_avtur, limit_avcat, id).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
      NotificationMailer.notify_email_combine(limit_diesel, 0, limit_avtur, id).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avcat > 0 && limit_diesel.emails==limit_avcat.emails
      NotificationMailer.notify_email_combine(limit_diesel, limit_petrol, 0, limit_avcat, id).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
      NotificationMailer.notify_email_combine(limit_diesel, limit_petrol, limit_avtur, 0, id).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
      NotificationMailer.notify_email_combine(limit_diesel, limit_petrol, 0, 0, id).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_avtur.emails
      NotificationMailer.notify_email_combine(limit_diesel, 0, limit_avtur, 0, id).deliver_now 
    elsif  surplus_avtur > 0 &&  surplus_petrol > 0 && limit_avtur.emails==limit_petrol.emails
      NotificationMailer.notify_email_combine(0, limit_petrol, limit_avtur, 0, id).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_avtur > 0 && limit_diesel.emails==limit_petrol.emails
      NotificationMailer.notify_email_combine(0, limit_petrol, limit_avtur, 0, id).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && limit_diesel.emails==limit_petrol.emails
      NotificationMailer.notify_email_combine(0, limit_petrol, 0, limit_avcat, id).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_diesel > 0 && limit_diesel.emails==limit_petrol.emails
      NotificationMailer.notify_email_combine(limit_diesel, 0, 0, limit_avcat, id).deliver_now 
    else
      if surplus_diesel > 0
        NotificationMailer.notify_email(limit_diesel, id).deliver_now
      end
      if surplus_petrol > 0 
        NotificationMailer.notify_email(limit_petrol, id).deliver_now
      end
      if surplus_avtur > 0 
        NotificationMailer.notify_email(limit_avtur, id).deliver_now
      end
      if surplus_avcat > 0 
        NotificationMailer.notify_email(limit_avcat, id).deliver_now
      end
    end
  end
  
end
