class FuelTransaction < ActiveRecord::Base

  def self.by_type(transaction_type)
    where(transaction_type: transaction_type)
  end
  
end
