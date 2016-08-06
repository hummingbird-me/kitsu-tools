import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  progress: 0,
  notes() { return faker.lorem.sentence(); },
  private() { return faker.random.boolean(); },
  rating() { return faker.random.number({ min: 0, max: 5, precision: 0.5 }); },
  reconsumeCount() { return faker.random.number(5); },
  status() { return faker.list.random('current', 'planned', 'completed', 'on_hold', 'dropped')(); },
  updatedAt() { return faker.date.past(); }
});
