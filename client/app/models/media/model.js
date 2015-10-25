import DS from 'ember-data';

const {
  Model,
  attr
} = DS;

export default Model.extend({
  abbreviatedTitles: attr('array'),
  averageRating: attr('number'),
  canonicalTitle: attr('string'),
  coverImage: attr('string'),
  coverImageTopOffset: attr('number'),
  endDate: attr('date'),
  posterImage: attr('string'),
  ratingFrequencies: attr('object'),
  slug: attr('string'),
  startDate: attr('date'),
  synopsis: attr('string'),
  titles: attr('object')
});
