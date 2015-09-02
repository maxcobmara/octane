$(document).ready(function(){
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').focus()
  });

  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
  
  //Date fields - start - https://bootstrap-datepicker.readthedocs.org/en/latest/
  $('[data-behaviour=datepicker_before]').datepicker({
    format: "yyyy-mm-dd",
    endDate: "today",
    autoclose: true
    //todayBtn: true
  });
  
  $('[data-behaviour=datepicker_after]').datepicker({
    format: "yyyy-mm-dd",
    startDate: "today",
    autoclose: true
    //todayBtn: true
  });
  
  $('[data-behaviour=datepicker_std]').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true
    //todayBtn: true
  });
  
  $('[data-behaviour=datepicker_year]').datepicker({
      format: "yyyy-mm-dd",
      endDate: "today",
      autoclose: true
//       startView: 1,
//       minViewMode: 2,
//        maxViewMode: 2,
//       daysOfWeekDisabled: "6"
  });
  //Date fields - end
  
  ///this must be activated if TURBOLINKS NOT in use
  $(".toga").click(function (e){
     $('.searchit').toggle();
  });

  $('.selectpicker').selectpicker();
  ///Turbolinks NOT in use
  
  ///Fuel Transaction - Use Fuel - start
  $("input[id='check_vehicle']").change(function() {  
    if($('#check_vehicle').is(':checked')) { 
      $("#span_vehicle").show("highlight"); 
      $("#span_vessel").hide("");
    }else{
      $("#span_vehicle").hide(""); 
      $("#span_vessel").show("highlight");
    }
  });

  $("input[id='check_vehicle']").each(function() {  
    if($('#check_vehicle').is(':checked')) { 
      $("#span_vehicle").show("highlight"); 
      $("#span_vessel").hide("");
    }else{
      $("#span_vehicle").hide(""); 
      $("#span_vessel").show("highlight");
    }
  });
  ///Fuel Transaction - Use Fuel - end
  
});

///searchit & selectpicker - if TURBOLINKS in use - ON PAGE CHANGE
// $(document).on('page:change', function () {
//   $('.selectpicker').selectpicker();
//   $(".toga").click(function (e){
//      $('.searchit').toggle();
//   });
//   ///Fuel Transaction - Use Fuel - start
//   $("input[id='check_vehicle']").change(function() {  
//     if($('#check_vehicle').is(':checked')) { 
//       $("#span_vehicle").show("highlight"); 
//       $("#span_vessel").hide("");
//     }else{
//       $("#span_vehicle").hide(""); 
//       $("#span_vessel").show("highlight");
//     }
//   });
// 
//   $("input[id='check_vehicle']").each(function() {  
//     if($('#check_vehicle').is(':checked')) { 
//       $("#span_vehicle").show("highlight"); 
//       $("#span_vessel").hide("");
//     }else{
//       $("#span_vehicle").hide(""); 
//       $("#span_vessel").show("highlight");
//     }
//   });
//   ///Fuel Transaction - Use Fuel - end
// });

/////searchit & selectpicker - if TURBOLINKS in use - ONCLICK EVENT
// $(document).on('click', 'toga', function(){
//   $('.searchit').toggle();
// });

//for use in generating repeating fields  -- Add more (Depot Fuels & Unit Fuels) - working ADD MORE for repeating fields but without Remove button
  function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).parent().before(content.replace(regexp, new_id));
  }
  
//    function remove_fields(link){
//      $(link).previous("input[type=hidden]").value = "1";
//      $(link).up(".fields").hide();
//    }
   
//not working yet - 1 Sept 2015 -  refer fuel_balance_fields.html.haml 
//    function test(link){
//      alert(link);
//      $(link).siblings("input[type=hidden]").value = "1";
//      $(link).siblings().hide();
//      $(link).hide();
//      
//     }

  