import DS from 'ember-data';
import Media from 'client/models/media/model';

const { attr } = DS;

export default Media.extend({
  ageRating: attr('number'),
  ageRatingGuide: attr('string'),
  episodeCount: attr('number'),
  episodeLength: attr('number'),
  showType: attr('number')
  // TODO: Computed properties for showType, ageRating, etc.
});
