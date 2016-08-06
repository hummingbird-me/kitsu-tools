import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  siteName() { return faker.company.companyName(); },
  logo() { return faker.image.business(); }
});
