HB.ResetScroll = Ember.Mixin.create({
  activate: function() {
    this._super();
    window.scrollTo(0, 0);
  }
});

// Mix into all routes.
Ember.Route.reopen(HB.ResetScroll);
