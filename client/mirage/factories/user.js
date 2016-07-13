import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  name() {
    return faker.internet.userName();
  },

  email() {
    return faker.internet.email();
  },

  password() {
    return faker.internet.password();
  }
});
