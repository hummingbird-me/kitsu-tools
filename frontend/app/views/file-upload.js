import Ember from 'ember';

export default Ember.TextField.extend({
  type: 'file',
  attributeBindings: ['name'],
  classNames: ['hidden'],
  file: null,

  change: function(evt) {
    var input = evt.target;
    if (input.files && input.files[0]) {
      // Update bindings
      var reader = new FileReader();
      reader.onload = (e) => Ember.run(() => this.set('file', e.target.result));
      reader.readAsDataURL(input.files[0]);

      // Send action
      this.sendAction('action', input.files[0]);
    }
  }
});
