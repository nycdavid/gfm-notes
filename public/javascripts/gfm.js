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

  $('body').on('click', 'button#save', function() {
    var newNotebookName = {
      title: $('#new-notebook-name').val(),
      file_name: $('#new-notebook-name').val().replace(/\s+/g, '-')
    }
    $(this).addClass('disabled'); // Disable the save
    $.ajax({
      type: 'POST',
      url: '/notebooks',
      dataType: 'JSON',
      data: newNotebookName,
      statusCode: {
        200: function(notebook) {
          $('button#save').removeClass('disabled'); // Re-enable save button
          $('#new-notebook-name').val(''); // Clear notebook name value
          $('h4.modal-title').after("<div class='alert alert-success'>Notebook successfully created!</div>");
          $('#notebooks ul').append('<li><a href="/notebooks/' + notebook.name + '">' + notebook.name + '</a></li>');
        },
        500: function(notebook) {
          var data = JSON.parse(notebook.responseText);
          $('h4.modal-title').after("<div class='alert alert-danger'>The notebook " + data.name + ' ' + data.message + ".</div>");
          $('button#save').removeClass('disabled'); // Re-enable save button
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
