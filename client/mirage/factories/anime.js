import Media from 'client/mirage/factories/media';
import { faker } from 'ember-cli-mirage';

export default Media.extend({
  ageRating() { return faker.list.random('G', 'PG', 'R', 'R18')(); },
  ageRatingGuide: '',
  showType() { return faker.list.random('TV', 'special', 'OVA', 'ONA', 'music', 'movie')(); },
  youtubeVideoId: '_NXrTujMP50'
});
