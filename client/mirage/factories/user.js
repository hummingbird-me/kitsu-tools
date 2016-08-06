import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  about() { return faker.lorem.paragraph(); },
  aboutFormatted() { return this.about; },
  avatar() { return faker.internet.avatar(); },
  bio() { return faker.lorem.sentence(); },
  coverImage() { return faker.image.image(); },
  email() { return faker.internet.email(); },
  followersCount() { return faker.random.number(100); },
  followingCount() { return faker.random.number(100); },
  location() { return faker.address.country(); },
  onboarded() { return faker.random.boolean(); },
  password() { return faker.internet.password(); },
  pastNames: [],
  name() { return faker.internet.userName(); },
  toFollow() { return faker.random.boolean(); },
  waifuOrHusbando() { return faker.list.random('Waifu', 'Husbando')(); },
  website() { return faker.internet.domainName(); }
});
