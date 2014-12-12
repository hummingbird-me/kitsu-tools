import Ember from 'ember';

export default Ember.ObjectController.extend({
  activeTab: "Genres",

  showGenres: Ember.computed.equal('activeTab', 'Genres'),
  showCharacters: Ember.computed.equal('activeTab', 'Characters'),

  actions: {
    switchTo: function (newTab) {
      return this.set('activeTab', newTab);
    }
  }
});
