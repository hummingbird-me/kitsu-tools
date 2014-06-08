Ember.Application.initializer({
  name: 'csrf-token',
  initialize: function () {
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      if (!options.crossDomain && csrfToken) {
        return jqXHR.setRequestHeader('X-CSRF-Token', csrfToken);
      }
    });
  }
});
