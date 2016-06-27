import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  siteName() {
    return faker.internet.domainName();
  },
  logo() {
    return faker.image.imageUrl();
  }
});
