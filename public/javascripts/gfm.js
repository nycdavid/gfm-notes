$(document).ready(function() {
  $('h2').click(function() {
    $(this).nextAll('ul:first').slideToggle(); 
  });

  // Completed tasks should go to the bottom of the list
  $('del').each(function(i) {
    var parent_ul = $(this).closest('ul');
    var li = $(this).parent('li');

    $(parent_ul).append($(li).detach());
  });
});
