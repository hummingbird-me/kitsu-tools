import Ember from 'ember';
/* global _bsap */

export default Ember.Component.extend({
  classNames: ['ad-unit'],
  adClass: null,
  adId: null,
  responsiveId: null,
  responsiveWidth: null,

  displayId: function() {
    if (this.get('responsiveId') && this.get('responsiveWidth') && this.get('responsiveWidth') > Ember.$(window).width) {
      return this.get('responsiveId');
    } else {
      return this.get('adId');
    }
  }.property('adId', 'responsiveId'),

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
