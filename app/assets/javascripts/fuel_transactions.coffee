# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# jQuery ->
#   $('.selectpicker').selectpicker('refresh');
#   $('#fuel_transaction_fuel_type_id').change ->
#     
#     tanks = $('#fuel_transaction_fuel_tank_id').html()
#   
#     fueltype = $('#fuel_transaction_fuel_type_id :selected').text()
#     escaped_fueltype = fueltype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#    
#     options2 = $(tanks).filter("optgroup[label=#{escaped_fueltype}]").html()
#     
#     
#     if options2
#       $('#fuel_transaction_fuel_tank_id').html(options2)
#       $('#fuel_transaction_fuel_tank_id').parent().show()
#     else
#       $('#fuel_transaction_fuel_tank_id').empty
#       $('#fuel_transaction_fuel_tank_id').parent().hide()

$(document).on "page:change", ->
  #alert "change"
  #jQuery ->
  vehicles = $('#fuel_transaction_vehicle_id').html()
  tanks = $('#fuel_transaction_fuel_tank_id').html()
  $('#fuel_transaction_fuel_type_id').change ->
    fueltype = $('#fuel_transaction_fuel_type_id :selected').text()
    escaped_fueltype = fueltype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vehicles).filter("optgroup[label=#{escaped_fueltype}]").html()
    options2 = $(tanks).filter("optgroup[label=#{escaped_fueltype}]").html()
    if options
      $('#fuel_transaction_vehicle_id').html(options)
      $('#fuel_transaction_vehicle_id').parent().show()
      $('#fuel_transaction_fuel_tank_id').html(options2)
      $('#fuel_transaction_fuel_tank_id').parent().show()
    else
      $('#fuel_transaction_vehicle_id').empty
      $('#fuel_transaction_vehicle_id').parent().hide()
      $('#fuel_transaction_fuel_tank_id').empty
      $('#fuel_transaction_fuel_tank_id').parent().hide()