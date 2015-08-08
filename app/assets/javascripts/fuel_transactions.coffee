# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $(document).on 'ready page:load', ->
    $('.selectpicker').selectpicker('refresh');
    vehicles = $('#fuel_transaction_vehicle_id').html()
    tanks = $('#fuel_transaction_fuel_tank_id').html()
    
    fueltype = $('#fuel_transaction_fuel_type_id :selected').text()
    escaped_fueltype = fueltype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vehicles).filter("optgroup[label=#{escaped_fueltype}]").html()
    options2 = $(tanks).filter("optgroup[label=#{escaped_fueltype}]").html()
    
    if options 
      $('#fuel_transaction_vehicle_id').html(options)
      $('#fuel_transaction_vehicle_id').parent().show()
    else
      $('#fuel_transaction_vehicle_id').empty
      $('#fuel_transaction_vehicle_id').parent().hide()
    if options2
      $('#fuel_transaction_fuel_tank_id').html(options2)
      $('#fuel_transaction_fuel_tank_id').parent().show()
    else
      $('#fuel_transaction_fuel_tank_id').empty
      $('#fuel_transaction_fuel_tank_id').parent().hide()

  $('#fuel_transaction_fuel_type_id').change ->
    $('.selectpicker').selectpicker('refresh');
    vehicles = $('#fuel_transaction_vehicle_id').html()
    tanks = $('#fuel_transaction_fuel_tank_id').html()
  
    fueltype = $('#fuel_transaction_fuel_type_id :selected').text()
    escaped_fueltype = fueltype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vehicles).filter("optgroup[label=#{escaped_fueltype}]").html()
    options2 = $(tanks).filter("optgroup[label=#{escaped_fueltype}]").html()
    
    if options 
      $('#fuel_transaction_vehicle_id').html(options)
      $('#fuel_transaction_vehicle_id').parent().show()
    else
      $('#fuel_transaction_vehicle_id').empty
      $('#fuel_transaction_vehicle_id').parent().hide()
    if options2
      $('#fuel_transaction_fuel_tank_id').html(options2)
      $('#fuel_transaction_fuel_tank_id').parent().show()
    else
      $('#fuel_transaction_fuel_tank_id').empty
      $('#fuel_transaction_fuel_tank_id').parent().hide()
