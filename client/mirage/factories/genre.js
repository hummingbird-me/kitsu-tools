import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  name() { return faker.lorem.word(); },
  slug() { return faker.helpers.slugify(this.name); },
  description() { return faker.lorem.sentence(); }
});
