$(document).ready(function(){
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').focus()
  });

  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
  
  $(".toga").click(function (e){
     $('.searchit').toggle();
  });

  $('.selectpicker').selectpicker();
});

$(document).on('page:change', function () {
  $('.selectpicker').selectpicker();
  //$(".toga").click(function (e){
  //   $('.searchit').toggle();
  //});
});
