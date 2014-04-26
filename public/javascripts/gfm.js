$(document).ready(function() {
  $('h2').click(function() {
    $(this).nextAll('ul:first').slideToggle(); 
  });
});
