Hummingbird.Pollster = Em.Object.extend({
  timer: null,


  start: function() {
    var _this = this;
    return this.set('timer', Ember.run.later(this, function() {
      _this.onPoll();
      return _this.start();
    }, 120000));
  },

  stop: function() {
    var timer = this.get('timer');
    return Ember.run.cancel(timer);
  },
  
  onPoll: function() {}
});
