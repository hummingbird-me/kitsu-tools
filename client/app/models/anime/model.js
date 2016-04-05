import computed from 'ember-computed';
import get from 'ember-metal/get';
import attr from 'ember-data/attr';
import Media from 'client/models/media/model';

export default Media.extend({
  ageRating: attr('string'),
  ageRatingGuide: attr('string'),
  episodeCount: attr('number'),
  episodeLength: attr('number'),
  showType: attr('number'),

  typeStr: computed('showType', {
    get() {
      const types = ['TV', 'Special', 'ONA', 'OVA', 'Movie', 'Music'];
      const type = get(this, 'showType');
      return types[type - 1];
    }
  })
});
