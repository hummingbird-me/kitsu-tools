Ember.Application.initializer({
  name: 'csrf-token',
  initialize: function () {
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    var csrfParam = $('meta[name="csrf-param"]').attr('content');
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      if (!options.crossDomain && csrfToken && csrfParam) {
        var newData = {};
        newData[csrfParam] = csrfToken;
        options.data = $.param($.extend(originalOptions.data, newData));
      }
    });
  }
});
