import Ember from 'ember';

export default Ember.Component.extend({
  checkInView: function() {
    var elementBottom = this.$().offset().top + this.$().height(),
        windowBottom = window.pageYOffset + Ember.$(window).height();

    if (elementBottom < windowBottom + 500) {
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
