module ApplicationHelper

  ###devise
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

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
  
  #Turns decimal into Ringgit
  def ringgols(money)
    number_to_currency(money, :unit => "RM ", :separator => ".", :delimiter => ",", :precision => 2)
  end
  
  #http://stackoverflow.com/questions/23777751/link-to-add-fields-unobtrusive-javascript-rails-4
  def link_to_add_fields(name, f, association, cssClass, title)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to name, "#", :onclick => h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => cssClass, :title => title
    ##link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
#   def link_to_remove_fields(name, f)
#     #f.hidden_field(:_destroy)+link_to_function(name, "remove_fields(this)")
#     f.hidden_field(:_destroy)+link_to name, "#", :onclick => h("remove_fields(this)")
#   end
  
  def is_admin(current_user)
    current_user.roles[:user_roles][:administration] 
  end
  
end
