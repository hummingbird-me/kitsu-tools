import Ember from 'ember';

export default Ember.Mixin.create({
    truncatedBio: Ember.computed('bio', {
      get() {
        return this.get('bio') || "";
      },

      set(key, value) {
        this.set('bio', value.slice(0, 140));
        return this.get('bio');
      }
    }),

    truncatedAbout: Ember.computed('about', {
      get() {
        return this.get('about') || "";
      },

      set(key, value) {
        this.set('about', value.slice(0, 500));
        return this.get('about');
      }
    })
});
