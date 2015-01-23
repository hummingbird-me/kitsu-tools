import DS from 'ember-data';
import Model from '../models/model';
import ModelCurrentUser from '../mixins/model-current-user';

export default Model.extend(ModelCurrentUser, {
  type: DS.attr('string'),
  user: DS.belongsTo('user'),
  poster: DS.belongsTo('user'),
  group: DS.belongsTo('group'),
  createdAt: DS.attr('date'),
  comment: DS.attr('string'),
  media: DS.belongsTo('media', { polymorphic: true }),
  substories: DS.hasMany('substory'),
  substoryCount: DS.attr('number'),
  totalVotes: DS.attr('number'),
  isLiked: DS.attr('boolean'),
  adult: DS.attr('boolean'),
  recentLikers: DS.hasMany('user'),

  coverImageStyle: function() {
    return "background-image: url(" + this.get('coverImageUrl') + ")";
  }.property('coverImageUrl'),

  omittedSubstoryCount: function(){
    return this.get('substoryCount') - 2;
  }.property('substoryCount'),

  belongsToUser: function() {
    var currentUserId = this.get('currentUser.id');
    return currentUserId === this.get('poster.id') || currentUserId === this.get('user.id');
  }.property('poster.id', 'user.id'),

  canDeleteStory: function() {
    var groupMember = this.get('group') && this.get('group').isMember(this.get('currentUser'));
    return (!this.get('isNew')) && (this.get('belongsToUser') || this.get('currentUser.isAdmin') ||
      (groupMember && (groupMember.get('isAdmin') || groupMember.get('isMod'))));
  }.property('isNew', 'belongsToUser', 'currentUser.isAdmin', 'group'),
});
