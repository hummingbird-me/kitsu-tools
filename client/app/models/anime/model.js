import attr from 'ember-data/attr';
import Media from 'client/models/media/model';
import EpisodicModel from 'client/mixins/episodic-model';

export default Media.extend(EpisodicModel, {
  ageRating: attr('string'),
  ageRatingGuide: attr('string'),
  showType: attr('string'),
  youtubeVideoId: attr('string')

  /* TODO: Relationship with Streaming Links */
});
