Hummingbird.FileUpload = Ember.TextField.extend({
  type: 'file',
  attributeBindings: ['name'],
  classNames: ['hidden'],

  change: function(evt) {
    var input = evt.target;
    if (input.files && input.files[0]) {
      return this.sendAction('action', input.files[0]);
    }
  }
});
