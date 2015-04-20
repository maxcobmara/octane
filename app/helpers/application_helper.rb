module ApplicationHelper

  #null helper by mymn
#use check kin {model.relation.field}
#see "how to use a nuclear submarine as a nutcracker"
  def check_kin
    begin
       return yield
       print "check_kin deprecated. Use .try(:objects)"
    rescue
       return " Data Not Available "
    end
  end

  def litres(number)
    "#{number} LTR"
  end
end
