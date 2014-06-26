Hummingbird.TruncateTextComponent = Ember.Component.extend({
  expanded: false,


  isTruncated: function() {
    return this.get('text').length > this.get('length') + 10;
  }.property('text', 'length'),

  truncatedText: function() {
    if (this.get('isTruncated') && !this.get('expanded')) {
      return jQuery.trim(this.get('text')).substring(0, this.get('length')).trim(this) + "…";
    } else {
      return this.get('text');
    }
  }.property('text', 'length', 'expanded'),
  
  actions: {
    toggleExpansion: function() {
      return this.toggleProperty('expanded');
    }
  }
});