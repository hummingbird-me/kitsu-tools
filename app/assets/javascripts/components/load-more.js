Hummingbird.LoadMoreComponent = Ember.Component.extend({
  checkInView: function() {
    var elementBottom = this.$().offset().top + this.$().height(),
        windowBottom = window.scrollY + Ember.$(window).height();
    if (elementBottom < windowBottom + 200) {
      this.sendAction();
    }
  },

  didInsertElement: function() {
    Ember.$(window).bind('scroll.loadMore', Ember.$.proxy(this.checkInView, this));
    this.checkInView();
  },

  willClearRender: function() {
    this.$(window).unbind('scroll.loadMore');
  }
});
