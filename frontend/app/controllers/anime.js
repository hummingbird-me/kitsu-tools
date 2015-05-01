import Ember from 'ember';

export default Ember.Controller.extend({
  noCoverImage: function() {
    return !this.get('model.coverImage');
  }.property('model.coverImage'),

  coverImageStyle: function() {
    var coverImage = this.get('model.coverImage');
    if (!coverImage) { return false; }
    var coverImageTopOffset = this.get('model.coverImageTopOffset');
    return (`background-image: url('${coverImage}'); background-position: 50% -${coverImageTopOffset}px;`).htmlSafe();
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  randomQuote: function() {
    var quoteCount = this.get('model.featuredQuotes.length');
    if (quoteCount === 0) { return null; }
    var index = Math.floor(Math.random() * quoteCount);
    return this.get('model.featuredQuotes').objectAt(index);
  }.property('model.featuredQuotes')
});
