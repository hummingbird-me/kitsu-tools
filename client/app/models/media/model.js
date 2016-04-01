import computed from 'ember-computed';
import get from 'ember-metal/get';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

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
  titles: attr('object'),
  youtubeVideoId: attr('string'),

  genres: hasMany('genre'),

  searchStr: computed('titles', {
    get() {
      const titles = get(this, 'titles');
      let searchStr = '';
      for (const key in titles) {
        searchStr += titles[key];
      }
      return searchStr.toLowerCase();
    }
  })
});
