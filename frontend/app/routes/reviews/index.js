import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('review', {
      anime_id: this.modelFor('anime').get('id'),
      page: page
    });
  },

  afterModel: function() {
    var anime = this.modelFor('anime');
    return setTitle(anime.get('canonicalTitle') + " Reviews");
  }
});
