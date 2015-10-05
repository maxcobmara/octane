class NotificationMailer < ActionMailer::Base
  default from: "octanenotify@gmail.com"
  
  def notify_email(fuel_limit, depot_fuel_id)
    @fuel_limit=fuel_limit
    @depot_fuel=DepotFuel.where(id: depot_fuel_id).first
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_combine(limit_diesel, limit_petrol, limit_avtur, limit_avcat, depot_fuel_id)
    @diesel_limit=limit_diesel
    @petrol_limit=limit_petrol
    @avtur_limit=limit_avtur
    @avcat_limit=limit_avcat
    @depot_fuel=DepotFuel.where(id: depot_fuel_id).first
    mail(to: @diesel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_transaction(fuel_limit, fuel_transaction)
    @fuel_limit=fuel_limit
    @fuel_transaction=fuel_transaction
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  def notify_email_combine_transaction(limit_diesel, limit_petrol, limit_avtur, limit_avcat, fuel_transaction)
    @diesel_limit=limit_diesel
    @petrol_limit=limit_petrol
    @avtur_limit=limit_avtur
    @avcat_limit=limit_avcat
    @fuel_transaction=fuel_transaction
    mail(to: @diesel_limit.emails, subject: 'Notification Email')
  end
  
  #for checking - fuel limit
  def notify_email2(fuel_limit)
    @fuel_limit=fuel_limit
    mail(to: @fuel_limit.emails, subject: 'Notification Email')
  end
  
  
end
