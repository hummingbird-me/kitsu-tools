import Ember from 'ember';

export default Ember.Controller.extend({
  advancedRating: Ember.computed.equal('currentUser.ratingType', "advanced"),
  simpleRating: Ember.computed.not('advancedRating'),
  saving: false,

  actions: {
    setRatingType: function(newType) {
      if (newType === "simple" || newType === "advanced") {
        var self = this;
        this.set('currentUser.ratingType', newType);
        this.set('saving', true);
        this.get('currentUser.content.content').save().then(function() {
          self.set('saving', false);
        });
      }
    }
  }
});
