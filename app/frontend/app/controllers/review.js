import Ember from 'ember';

export default Ember.ObjectController.extend({
  positive: Ember.computed.gt('rating', 2.5)
});
