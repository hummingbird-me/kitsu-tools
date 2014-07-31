Hummingbird.PostCommentComponent = Ember.Component.extend({
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
      var self = this,
          newPost = this.get('newPost');

      if (newPost.length > 0) {
        this.set('inFlight', true);
        ic.ajax({
          url: "/users/" + self.get('username') + "/comment.json",
          data: { comment: newPost },
          type: "POST"
        }).then(function() {
          self.setProperties({
            newPost: "",
            inFlight: false
          });
          window.location.href = window.location.href;
        }, function() {
          alert("Failed to save comment");
        });
      }
    }
  }
});
