import Em from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  sourceType: DS.attr('string'),
  sourceUser: DS.attr('string'),
  sourceAvatar: DS.attr('string'),
  createdAt: DS.attr('date'),
  notificationType: DS.attr('string'),
  seen: DS.attr('boolean'),

  isProfileComment: Em.computed.equal('notificationType', "profile_comment"),
  isCommentReply: Em.computed.equal('notificationType', "comment_reply"),

  link: function() {
    return "/notifications/" + this.get('id');
  }.property('id')
});
