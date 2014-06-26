Hummingbird.InstantSearchComponent = Ember.TextField.extend({
  didInsertElement: function() {
    return this.$().focus();
  },
  
  focusOut: function() {
    return this.sendAction('focusLost');
  }
});