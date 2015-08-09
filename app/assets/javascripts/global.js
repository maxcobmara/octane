$(document).ready(function(){
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').focus()
  });

  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });

  $('.selectpicker').selectpicker();
});

$(document).on('page:change', function () {
  $('.selectpicker').selectpicker();
});
