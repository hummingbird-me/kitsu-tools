Hummingbird.DashboardView = Ember.View.extend({
  didInsertElement: function() {
    var self = this;
    this.$(".status-form").focus(function() {
      self.$(".status-form").autosize({append: "\n"});
      self.$(".status-update-panel .panel-footer").slideDown(200);
    });
    this.$(".status-form").blur(function() {
      if (self.$(".status-form").val().replace(/\s/g, '').length === 0) {
        self.$(".status-form").val('');
        self.$(".status-form").trigger("autosize.destroy");
        self.$(".status-update-panel .panel-footer").slideUp(200);
      }
    });
  },

  willClearRender: function() {
    this.$(".status-form").trigger("autosize.destroy");
  }
});
