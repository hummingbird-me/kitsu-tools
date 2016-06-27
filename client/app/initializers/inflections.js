import Ember from 'ember';

const {
  Inflector: { inflector }
} = Ember;

export function initialize() {
  inflector.uncountable('anime');
  inflector.uncountable('manga');
  inflector.uncountable('drama');
}

export default {
  name: 'inflections',
  before: 'ember-cli-mirage',
  initialize
};
