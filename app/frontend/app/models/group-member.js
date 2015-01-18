import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  group: DS.belongsTo('group'),
  user: DS.belongsTo('user'),
  rank: DS.attr('string'),
  pending: DS.attr('boolean'),

  isAdmin: Ember.computed.equal('rank', 'admin'),
  isMod: Ember.computed.equal('rank', 'mod')
});
