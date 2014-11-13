HB.TruncateTextComponent = Ember.Component.extend({
  expanded: false,
  breakLines: false,

  isTruncated: function() {
    return this.get('text').length > this.get('length') + 10;
  }.property('text', 'length'),

  truncatedText: function() {
    var text = this.get('text');
    if (this.get('isTruncated') && !this.get('expanded')) {
      text = jQuery.trim(text).substring(0, this.get('length')).trim(this) + "…";
    }
    if (this.get('breakLines')) {
      text = escapeHTML(text).replace("\n", "<br>").htmlSafe();
    }
    return text;
  }.property('text', 'length', 'expanded', 'breakLines'),

  actions: {
    toggleExpansion: function() {
      return this.toggleProperty('expanded');
    }
  }
});
