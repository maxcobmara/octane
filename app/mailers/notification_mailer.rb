class NotificationMailer < ActionMailer::Base
  default from: "octanenotify@gmail.com"
  
  def notify_email(fuel_limit, depot_fuel_id, fuel_budget)
    @fuel_limit=fuel_limit
    @fuel_budget=fuel_budget
    @depot_fuel=DepotFuel.where(id: depot_fuel_id).first
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_combine(l_diesel, l_petrol, l_avtur, l_avcat, depot_fuel_id, b_diesel, b_petrol, b_avtur, b_avcat)
    @diesel_limit=l_diesel
    @petrol_limit=l_petrol
    @avtur_limit=l_avtur
    @avcat_limit=l_avcat
    @diesel_budget=b_diesel
    @petrol_budget=b_petrol
    @avtur_budget=b_avtur
    @avcat_budget=b_avcat
    @depot_fuel=DepotFuel.where(id: depot_fuel_id).first
    if @diesel_limit !=0
      @fuel_limit=@diesel_limit
    elsif @petrol_limit !=0
      @fuel_limit=@petrol_limit
    elsif @avtur_limit !=0
      @fuel_limit=@avtur_limit
    elsif @avcat_limit !=0
      @fuel_limit=@avcat_limit
    end
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_transaction(fuel_limit, fuel_transaction_id, fuel_budget)
    @fuel_limit=fuel_limit
    @fuel_budget=fuel_budget
    @fuel_transaction=FuelTransaction.where(id: fuel_transaction_id).first
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_combine_transaction(l_diesel, l_petrol, l_avtur, l_avcat, fuel_transaction_id, b_diesel, b_petrol, b_avtur, b_avcat)
    @diesel_limit=l_diesel
    @petrol_limit=l_petrol
    @avtur_limit=l_avtur
    @avcat_limit=l_avcat
    @diesel_budget=b_diesel
    @petrol_budget=b_petrol
    @avtur_budget=b_avtur
    @avcat_budget=b_avcat
    if @diesel_limit !=0
      @fuel_limit=@diesel_limit
    elsif @petrol_limit !=0
      @fuel_limit=@petrol_limit
    elsif @avtur_limit !=0
      @fuel_limit=@avtur_limit
    elsif @avcat_limit !=0
      @fuel_limit=@avcat_limit
    end
    @fuel_transaction=FuelTransaction.where(id: fuel_transaction_id).first
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  #for checking - fuel limit
  def notify_email2(fuel_limit)
    @fuel_limit=fuel_limit
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end

end
