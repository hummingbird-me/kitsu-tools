Hummingbird.TitleManager = Ember.Object.extend({
  title: null,

  // Public interface for setting page titles.
  setTitle: function(title) {
    return this.set('title', title);
  },

  // Observer that gets triggered whenever the title is changed.
  setPageTitle: (function() {
    if (this.get("title")) {
      return this.actuallySetTitle(this.get("title") + " | Hummingbird");
    } else {
      return this.actuallySetTitle("Hummingbird");
    }
  }).observes('title').on('init'),

  // Actually set the page title.
  actuallySetTitle: function(title) {
    document.title = title;
    return $("meta[name='og:title']").attr('content', title);
  }
}).create();
