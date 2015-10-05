import Ember from 'ember';
import DS from 'ember-data';

const { Mixin } = Ember;
const { attr } = DS;

export default Mixin.create({
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
