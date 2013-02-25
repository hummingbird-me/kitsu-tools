$(function () {
  
  $(document).ready(function() {
    $('.login-input').each(function() {
      var p = $(this).parent();
      if ($(this).val().trim() === '') {
        $(this).val('');
        $('.fc-login-input-ghost', p).show();
      } else {
        $('.fc-login-input-ghost', p).hide();
      }
    })
  });

  // input control
  $('.login-input').focus(function () {
    var p = $(this).parent();
    $('.login-input-ghost', p).hide();
    p.parent().css({ background: '#ffffff' });
  });

  $('.login-input').blur(function () {
    var p = $(this).parent();
    if ($(this).val().trim() === '') {
      $(this).val('');
      $('.login-input-ghost', p).show();
    }
    p.parent().css({ background: '#fcfcfc' });
  });

});