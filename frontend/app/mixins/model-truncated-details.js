import Ember from 'ember';

export default Ember.Mixin.create({
    truncatedBio: function(key, value) {
      // setter
      if (arguments.length > 1) {
        this.set('bio', value.slice(0, 140));
      }

      // getter
      return this.get('bio') || "";
    }.property('bio'),

    truncatedAbout: function(key, value) {
      // setter
      if (arguments.length > 1) {
        this.set('about', value.slice(0, 500));
      }

      // getter
      return this.get('about') || "";
    }.property('about')
});
