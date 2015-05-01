import Ember from 'ember';

export default Ember.Controller.extend({
  coverImageStyle: function() {
    return (`background-image: url("${this.get('model.user.coverImageUrl')}")`).htmlSafe();
  }.property('model.user.coverUrl'),

  writtenBySelf: function() {
    return this.get('currentUser.isSignedIn') && this.get('currentUser.id') === this.get('model.user.id');
  }.property('model.user.id'),

  ratingFirstDigit: function() {
    return Math.floor(this.get('model.rating'));
  }.property('model.rating'),

  ratingDecimalPart: function() {
    return "." + (Math.floor((this.get('model.rating') - this.get('ratingFirstDigit')) * 10));
  }.property('model.rating'),

  breakdown: function() {
    var self = this,
        breakdown = [];
    ['model.ratingStory', 'model.ratingAnimation', 'model.ratingSound', 'model.ratingCharacters', 'model.ratingEnjoyment'].forEach(function(property) {
      return breakdown.push(Ember.Object.create({
        title: property.substr(12),
        positive: self.get(property) > 2.4,
        rating: self.get(property).toFixed(1)
      }));
    });
    return breakdown;
  }.property('model.ratingStory', 'model.ratingAnimation', 'model.ratingSound', 'model.ratingCharacters', 'model.ratingEnjoyment'),

  editPath: function() {
    return "/anime/" + this.get('model.anime.id') + "/reviews/" + this.get('model.id') + "/edit";
  }.property('model.id', 'model.anime.id'),

  upvoted: function() {
    return this.get('model.liked') === "true";
  }.property('model.liked'),

  downvoted: function() {
    return this.get('model.liked') === "false";
  }.property('model.liked')
});
