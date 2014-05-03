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

  $('body').on('click', '.alert', function() {
    $(this).remove();
  });

  $('body').on('click', '.save', function() {
    var nameObj = {
      title: $('#new-resource-name').val(),
      file_name: $('#new-resource-name').val().replace(/\s+/g, '-')
    }
    $(this).addClass('disabled'); // Disable save button
    $.ajax({
      type: 'POST',
      url: $('.modal').data('url'),
      dataType: 'JSON',
      data: nameObj,
      statusCode: {
        200: function(resource) {
          $('.save').removeClass('disabled'); // Re-enable save button
          $('#new-resource-name').val(''); // Clear notebook name value
          $('h4.modal-title').after("<div class='alert alert-success'>Notebook successfully created!</div>");
          $('#notebooks ul').append('<li><a href="' + resource.url + '">' + resource.name + '</a></li>');
        },
        500: function(resource) {
          var data = JSON.parse(resource.responseText);
          $('h4.modal-title').after("<div class='alert alert-danger'>The resource " + data.name + ' ' + data.message + ".</div>");
          $('.save').removeClass('disabled'); // Re-enable save button
        }
      }
    });
  });
});

function completedTasks() {
  $('del').each(function(i) {
    var parent_ul = $(this).closest('ul');
    var li = $(this).parent('li');
    $(parent_ul).append($(li).detach());
  });
}
