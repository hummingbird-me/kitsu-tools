import Ember from 'ember';

export default Ember.Controller.extend({
  positive: Ember.computed.gt('model.rating', 2.5)
});
