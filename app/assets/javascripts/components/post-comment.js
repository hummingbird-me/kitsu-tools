Hummingbird.PostCommentComponent = Ember.Component.extend({
  classNames: ["status-update-panel"],

  didInsertElement: function() {
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

  actions: {
    submitPost: function() {
      this.sendAction('action', this.get('newPost'));
    }
  }
});
