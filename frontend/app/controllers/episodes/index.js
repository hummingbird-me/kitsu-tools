import Ember from 'ember';

export default Ember.ArrayController.extend({
  needs: ['anime'],
  anime: Ember.computed.alias('controllers.anime')
});
