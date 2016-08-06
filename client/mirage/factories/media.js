import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  abbreviatedTitles: [],
  averageRating() { return faker.random.number({ min: 0, max: 5, precision: 0.5 }); },
  canonicalTitle() { return faker.name.findName(); },
  coverImage() { return faker.image.image(); },
  coverImageTopOffset: 0,
  endDate() { return faker.date.future(); },
  posterImage() { return faker.image.image(); },
  ratingFrequencies: [],
  slug() { return faker.helpers.slugify(this.canonicalTitle); },
  startDate() { return faker.date.past(); },
  synopsis() { return faker.lorem.paragraphs(); },
  titles: {}
});
