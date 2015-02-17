import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  user: DS.belongsTo('user'),
  rank: DS.attr('string'),
  pending: DS.attr('boolean'),
  groupId: DS.attr('string'),

  // This suffers the same problem as `substories`, where the
  // relationship only serializes a subset of `group-members`,
  // rather than all and ember will destroy the relationship.
  group: function() {
    return this.store.find('group', this.get('groupId'));
  }.property('groupId'),

  isAdmin: Ember.computed.equal('rank', 'admin'),
  isMod: Ember.computed.equal('rank', 'mod'),
  isPleb: Ember.computed.equal('rank', 'pleb'),
  isNotPleb: Ember.computed.not('isPleb'),

  // ability properties
  canKickMember: Ember.computed.or('isAdmin', 'isMod'),
  canChangeRank: Ember.computed.alias('isAdmin')
});
