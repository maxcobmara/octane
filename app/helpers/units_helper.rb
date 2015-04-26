module UnitsHelper
  def nested_groups(units)
    content_tag(:ul) do
      units.map do |unit, sub_units|
        content_tag(:li, (link_to "#{unit.shortname}  #{unit.name}", unit_path(unit))) + nested_groups(sub_units) 
      end.join.html_safe
    end
  end
end
