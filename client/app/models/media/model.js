import Ember from 'ember';
import DS from 'ember-data';

const {
  computed,
  get
} = Ember;

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
  genres: attr('array'),
  posterImage: attr('string'),
  ratingFrequencies: attr('object'),
  slug: attr('string'),
  startDate: attr('date'),
  synopsis: attr('string'),
  titles: attr('object'),

  searchStr: computed('titles', {
    get() {
      const titles = get(this, 'titles');
      let searchStr = '';
      for (let key in titles) {
        searchStr += titles[key];
      }
      return searchStr.toLowerCase();
    }
  })
});
