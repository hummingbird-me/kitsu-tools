import attr from 'ember-data/attr';
import Media from 'client/models/media/model';

export default Media.extend({
  mangaType: attr('string')
});
