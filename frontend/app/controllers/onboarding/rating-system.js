import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  advancedRating: Ember.computed.equal('currentUser.ratingType', "advanced"),
  simpleRating: Ember.computed.not('advancedRating'),
  saving: false,

  actions: {
    setRatingType: function(newType) {
      if (newType === "simple" || newType === "advanced") {
        var self = this;
        this.set('currentUser.ratingType', newType);
        this.set('saving', true);
        this.get('currentUser.model.content').save().then(function() {
          self.set('saving', false);
        });
      }
    }
  }
});
