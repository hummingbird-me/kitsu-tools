import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['group'],
  group: Ember.computed.alias('controllers.group.model'),
  suggestedGroups: null,

  isEditing: false,
  aboutCharacterCount: function() {
    return 500 - this.get('group.about').length;
  }.property('group.about'),
  aboutCharactersLeft: Ember.computed.gt('aboutCharacterCount', 0),

  actions: {
    editGroupDetails: function() {
      this.set('isEditing', true);
    },

    saveGroupDetails: function() {
      this.get('group').save();
      this.set('isEditing', false);
    }
  }
});
