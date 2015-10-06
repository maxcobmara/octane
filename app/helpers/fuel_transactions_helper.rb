module FuelTransactionsHelper
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
          usages_rec=FuelTransaction.where(transaction_type: 'Usage').where('created_at >=? and created_at <=?', limitstart, Date.today).where(fuel_tank_id: FuelTank.where(unit_id: limit.unit_id).where(fuel_type: FuelType.where(name:'PETROL')).pluck(:id))
        end
      end
    end
    usages_rec
  end
  
  def usage_amount(limit, budgets)
    usages(limit, budgets).sum(:amount)
  end
  
  def surplus_amount(limit, budgets)
    if limit && usages(limit, budgets)
      if usages(limit, budgets).first.fuel_unit_type==limit.limit_unit_type 
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
    unitid=fuel_tank.unit_id
    l_diesel=diesel_limit(unitid)
    l_petrol=petrol_limit(unitid)
    l_avtur=avtur_limit(unitid)
    l_avcat=avcat_limit(unitid)
    b_diesel=diesel_budgets(unitid)
    b_petrol=petrol_budgets(unitid)
    b_avtur=avtur_budgets(unitid)
    b_avcat=avcat_budgets(unitid)
    surplus_diesel=surplus_amount(l_diesel, b_diesel)
    surplus_petrol=surplus_amount(l_petrol, b_petrol)
    surplus_avtur=surplus_amount(l_avtur, b_avtur)
    surplus_avcat=surplus_amount(l_avcat, b_avcat)
        
    if surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails &&  surplus_avcat > 0 && l_petrol.emails && l_avcat.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, l_petrol, l_avtur, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && l_avcat.emails==l_petrol.emails &&  surplus_avtur > 0 && l_avcat.emails==l_avtur.emails
        NotificationMailer.notify_email_combine_transaction(0, l_petrol, l_avtur, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avcat > 0 && l_diesel.emails==l_avcat.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, 0, l_avtur, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avcat > 0 && l_diesel.emails==l_avcat.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, l_petrol, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, l_petrol, 0, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_diesel > 0 &&  surplus_avtur > 0 && l_diesel.emails==l_avtur.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, 0, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avtur > 0 &&  surplus_petrol > 0 && l_avtur.emails==l_petrol.emails
        NotificationMailer.notify_email_combine_transaction(0, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_avtur > 0 && l_diesel.emails==l_petrol.emails
        NotificationMailer.notify_email_combine_transaction(0, l_petrol, l_avtur, 0, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_petrol > 0 && l_diesel.emails==l_petrol.emails
        NotificationMailer.notify_email_combine_transaction(0, l_petrol, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    elsif  surplus_avcat > 0 &&  surplus_diesel > 0 && l_diesel.emails==l_petrol.emails
        NotificationMailer.notify_email_combine_transaction(l_diesel, 0, 0, l_avcat, id, b_diesel, b_petrol, b_avtur, b_avcat).deliver_now 
    else
      if surplus_diesel > 0
        NotificationMailer.notify_email_transaction(l_diesel, id, b_diesel).deliver_now
      end
      if surplus_petrol > 0 
        NotificationMailer.notify_email_transaction(l_petrol, id, b_petrol).deliver_now
      end
      if surplus_avtur > 0 
        NotificationMailer.notify_email_transaction(l_avtur, id, b_avtur).deliver_now
      end
      if surplus_avcat > 0 
        NotificationMailer.notify_email_transaction(l_avcat, id, b_avcat).deliver_now
      end
    end
  end
end
