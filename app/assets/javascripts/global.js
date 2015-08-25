$(document).ready(function(){
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').focus()
  });

  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
  
  //$(".toga").click(function (e){
  //   $('.searchit').toggle();
  //});

  $('.selectpicker').selectpicker();
  
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

$(document).on('page:change', function () {
  $('.selectpicker').selectpicker();
  $(".toga").click(function (e){
     $('.searchit').toggle();
  });
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

$(document).on('click', 'toga', function(){
  $('.searchit').toggle();
});