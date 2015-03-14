import Ember from 'ember';

export default Ember.TextArea.extend({
  registerAutosize: function() {
    this.$().autosize({append: false});
  }.on('didInsertElement'),

  clearAutosize: function() {
    this.$().trigger('autosize.destroy');
  }.on('willClearRender'),

  keyDown: function(e) {
    if (e.keyCode === 13 && !e.shiftKey) {
      this.sendAction('enterAction');
      return false;
    }
  }
});
