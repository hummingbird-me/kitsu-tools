import DS from 'ember-data';
import MediaModelMixin from 'client/mixins/media-model';

const { Model, attr } = DS;

export default Model.extend(MediaModelMixin, {
  ageRating: attr('number'),
  ageRatingGuide: attr('string'),
  episodeCount: attr('number'),
  episodeLength: attr('number'),
  showType: attr('number')
  // TODO: Computed properties for showType, ageRating, etc.
});
