import DS from 'ember-data';
import Manga from '../models/manga';

export default Manga.extend({
  coverImage: DS.attr('string'),
  coverImageTopOffset: DS.attr('number'),
  featuredCastings: DS.hasMany('casting'),
  pendingEdits: DS.attr('number')
});
