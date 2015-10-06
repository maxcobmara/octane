module DepotFuelsHelper
  include FuelLimitsHelper
  include FuelBudgetsHelper
   
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
    l_diesel=diesel_limit(unit_id)
    l_petrol=petrol_limit(unit_id)
    l_avtur=avtur_limit(unit_id)
    l_avcat=avcat_limit(unit_id)
    b_diesel=diesel_budgets(unit_id)
    b_petrol=petrol_budgets(unit_id)
    b_avtur=avtur_budgets(unit_id)
    b_avcat=avcat_budgets(unit_id)
    surplus_diesel=surplus_amount(l_diesel, b_diesel)
    surplus_petrol=surplus_amount(l_petrol, b_petrol)
    surplus_avtur=surplus_amount(l_avtur, b_avtur)
    surplus_avcat=surplus_amount(l_avcat, b_avcat)
        
    if surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails &&  surplus_avcat > 0 && l_petrol.emails && l_avcat.emails
      NotificationMailer.notify_email_combine(l_diesel, l_petrol, l_avtur, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && l_avcat.emails==l_petrol.emails &&  surplus_avtur > 0 && l_avcat.emails==l_avtur.emails
      NotificationMailer.notify_email_combine(0, l_petrol, l_avtur, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avcat > 0 && l_diesel.emails==l_avcat.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
      NotificationMailer.notify_email_combine(l_diesel, 0, l_avtur, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avcat > 0 && l_diesel.emails==l_avcat.emails
      NotificationMailer.notify_email_combine(l_diesel, l_petrol, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
      NotificationMailer.notify_email_combine(l_diesel, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails
      NotificationMailer.notify_email_combine(l_diesel, l_petrol, 0, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
      NotificationMailer.notify_email_combine(l_diesel, 0, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avtur > 0 &&  surplus_petrol > 0 && l_avtur.emails==l_petrol.emails
      NotificationMailer.notify_email_combine(0, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_avtur > 0 && l_diesel.emails==l_petrol.emails
      NotificationMailer.notify_email_combine(0, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && l_avcat.emails==l_petrol.emails
      NotificationMailer.notify_email_combine(0, l_petrol, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_diesel > 0 && l_diesel.emails==l_petrol.emails
      NotificationMailer.notify_email_combine(l_diesel, 0, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    else
      if surplus_diesel > 0
        NotificationMailer.notify_email(l_diesel, id, b_diesel).deliver_now
      end
      if surplus_petrol > 0 
        NotificationMailer.notify_email(l_petrol, id, b_petrol).deliver_now
      end
      if surplus_avtur > 0 
        NotificationMailer.notify_email(l_avtur, id, b_avtur).deliver_now
      end
      if surplus_avcat > 0 
        NotificationMailer.notify_email(l_avcat, id, b_avcat).deliver_now
      end
    end
  end
  
end
