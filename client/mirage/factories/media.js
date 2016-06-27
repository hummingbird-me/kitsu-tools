import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  canonicalTitle(i) {
    return `Media: The Test #${i}`;
  },
  slug() {
    return faker.helpers.slugify(this.canonicalTitle);
  }
});
