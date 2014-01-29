Hummingbird.TimeAgoComponent = Ember.Component.extend({
  tagName: "span",
  time: null,
  interval: null,

  didInsertElement: function() {
    var fn = function() {
      this.$().html(moment(this.get('time')).fromNow());
    }.bind(this);
    fn();
    this.set('interval', setInterval(function() {
      Ember.run(function() { fn(); });
    }, 60000));
  },

  willClearRender: function() {
    clearInterval(this.get('interval'));
  }
});
