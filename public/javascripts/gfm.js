$(document).ready(function() {
  // Retrieve note name from document
  var noteName = $('#note-name').data('noteName');

  $('body').on('click', 'h2', function() {
    $(this).nextAll('ul:first').slideToggle();
  });

  // Completed tasks should go to the bottom of the list
  completedTasks();  

  // WebSocket logic
  var scheme = 'ws://';
  var uri = scheme + window.document.location.host + '/';
  var ws = new WebSocket(uri);

  // WebSocket receive message
  ws.onmessage = function(message) {
    var changedFile = JSON.parse(message.data);
    if (changedFile.name === noteName) {
      $('body').html(changedFile.markup);
      completedTasks();
    }
  };
});

function completedTasks() {
  $('del').each(function(i) {
    var parent_ul = $(this).closest('ul');
    var li = $(this).parent('li');
    $(parent_ul).append($(li).detach());
  });
}
