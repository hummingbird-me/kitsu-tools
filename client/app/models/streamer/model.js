import DS from 'ember-data';

const {
  Model,
  attr
} = DS;

export default Model.extend({
  siteName: attr('string'),
  logo: attr('string')
});
