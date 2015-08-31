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