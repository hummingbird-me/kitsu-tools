import Ember from 'ember';

export default Ember.Controller.extend({
  mobileApps: Ember.computed.filterBy('model', 'form', 'Mobile'),
  desktopApps: Ember.computed.filterBy('model', 'form', 'Desktop')
});
