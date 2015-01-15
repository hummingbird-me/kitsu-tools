import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ["status-update-panel"],
  formIsOpen: false,

  didInsertElement: function() {
    var self = this;
    this.$(".status-form").focus(function() {
      self.set('formIsOpen', true);
      self.handleFormState();
    });
    this.$(".status-form").blur(function() {
      if (self.$(".status-form").val().replace(/\s/g, '').length === 0) {
        self.set('formIsOpen', false);
        self.handleFormState();
      }
    });
    this.$("#status-box-text").click(function() {
      self.toggleProperty('newPostAdult');
    });
  },

  handleFormState: function() {
    var self = this;

    setTimeout(function() {
      if(self.get('formIsOpen')) {
        self.$(".status-form").autosize({append: "\n"});
        self.$(".panel-footer").slideDown(200);
      } else {
        self.$(".status-form").val('');
        self.$(".panel-footer").slideUp(200, function() {
          self.$(".status-form").trigger("autosize.destroy");
        });
      }
    }, 300);
  }.observes('formIsOpen'),

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
      var comment = this.get('newPost'),
          isAdult = this.get('newPostAdult');

      this.setProperties({
        'newPost': "",
        'newPostAdult': false
      });

      this.sendAction('action', {
        comment: comment,
        isAdult: isAdult
      });
    }
  }
});
