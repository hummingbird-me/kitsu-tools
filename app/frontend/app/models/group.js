import DS from 'ember-data';
import ModelTruncatedDetails from '../mixins/model-truncated-details';

export default DS.Model.extend(ModelTruncatedDetails, {
  name: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  coverImageUrl: DS.attr('string'),
  avatarUrl: DS.attr('string'),
  memberCount: DS.attr('number'),
  members: DS.hasMany('group-member'),
  currentMember: DS.belongsTo('group-member'),

  coverImageStyle: function() {
    return "background: url(" + this.get('coverImageUrl') + ") center;";
  }.property('coverImageUrl'),

  // Fixes the fact that viewing all members adds to the members
  // association.
  recentMembers: function() {
    var members = this.get('members');
    return members.filterBy('pending', false).slice(0, 14);
  }.property('members.@each'),

  getMember: function(user, includePending = false) {
    var members = this.get('members');
    if (!includePending) { members = members.filterBy('pending', false); }
    return members.findBy('user.id', user.get('id'));
  }
});
