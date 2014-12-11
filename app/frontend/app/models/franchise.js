import DS from 'ember-data';

export default DS.Model.extend({
  anime: DS.hasMany('anime')
});
