import computed from 'ember-computed';
import get from 'ember-metal/get';
import attr from 'ember-data/attr';
import Media from 'client/models/media/model';
import EpisodicModel from 'client/mixins/episodic-model';

export default Media.extend(EpisodicModel, {
  ageRating: attr('string'),
  ageRatingGuide: attr('string'),
  showType: attr('number'),
  youtubeVideoId: attr('string'),

  /* TODO: Relationship with Streaming Links */

  typeStr: computed('showType', {
    get() {
      const types = ['TV', 'Special', 'ONA', 'OVA', 'Movie', 'Music'];
      const type = get(this, 'showType');
      return types[type - 1];
    }
  })
});
