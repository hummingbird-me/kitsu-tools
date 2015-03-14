import DS from 'ember-data';

export default DS.ActiveModelAdapter.extend({
  pathForType: function() {
    return 'users';
  }
});
