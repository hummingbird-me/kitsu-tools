import Ember from 'ember';

var ONBOARDING_STRUCTURE = ['start', 'rating-system', 'categories', 'library', 'finish'];

export default Ember.Controller.extend({
  needs: ['application'],
  currentPath: Ember.computed.alias("controllers.application.currentPath"),

  currentStep: function(){
    var currentPage = this.get('currentPath').replace('onboarding.', '');
    return ONBOARDING_STRUCTURE.indexOf(currentPage) + 1;
  }.property('currentPath')
});
