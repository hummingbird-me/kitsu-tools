import Ember from 'ember';
import attr from 'ember-data/attr';
import Media from 'client/models/media/model';

const {
  get,
  computed
} = Ember;

export default Media.extend({
  ageRating: attr('string'),
  ageRatingGuide: attr('string'),
  episodeCount: attr('number'),
  episodeLength: attr('number'),
  showType: attr('number'),

  showTypeStr: computed('showType', {
    get() {
      const showTypes = ['TV', 'Special', 'ONA', 'OVA', 'Movie', 'Music'];
      const showType = get(this, 'showType');
      return showTypes[showType - 1];
    }
  })
});
