import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ["status-update-panel"],

  didInsertElement: function() {
    var self = this;
    this.$(".status-form").focus(function() {
      self.$(".status-form").autosize({append: "\n"});
      self.$(".panel-footer").slideDown(200);
    });
    this.$(".status-form").blur(function() {
      if (self.$(".status-form").val().replace(/\s/g, '').length === 0) {
        self.$(".status-form").val('');
        self.$(".panel-footer").slideUp(200, function() {
          self.$(".status-form").trigger("autosize.destroy");
        });
      }
    });
  },

  willClearRender: function() {
    this.$(".status-form").trigger("autosize.destroy");
  },

  // Submit on Cmd/Ctrl+Enter.
  keyDown: function(e) {
    if ((e.metaKey || e.ctrlKey) && e.keyCode === 13) {
      this.send('submitPost');
    }
  },

  actions: {
    submitPost: function() {
      var comment = this.get('newPost');
      this.set('newPost', "");
      this.sendAction('action', comment);
    }
  }
});
