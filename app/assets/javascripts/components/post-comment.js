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

  actions: {
    submitPost: function() {
      var _this = this
        , newPost = this.get('newPost');

      if (newPost.length > 0) {
        this.set('inFlight', true);
        return Ember.$.ajax({
          url: "/users/" + _this.get('username') + "/comment.json",
          data: { comment: newPost },
          type: "POST",
          success: function (payload) {
            _this.setProperties({
              newPost: "",
              inFlight: false
            });
            window.location.href = window.location.href;
          },
          error: function () {
            alert("Failed to save comment");
          }
        });
      }
    }
  }
});
