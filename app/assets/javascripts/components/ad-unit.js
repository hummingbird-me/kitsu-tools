Hummingbird.AdUnitComponent = Ember.Component.extend({
  classNames: ['ad-unit'],
  adClass: null,
  adId: null,


  divId: function() {
    return "bsap_" + this.get('adId');
  }.property('adId'),

  divClass: function() {
    return "bsarocks bsap_" + this.get('adClass');
  }.property('adClass'),
  
  didInsertElement: function() {
    if (typeof _bsap !== "undefined") {
      return _bsap.exec();
    }
  }
});
